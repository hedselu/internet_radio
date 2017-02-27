require 'singleton'

module Channels
  class WorkerContainer
    include Singleton

    Thread.report_on_exception = true

    attr_reader :logger
    attr_accessor :playlist, :threads, :channel_name

    delegate :[], to: :threads
    delegate :size, to: :threads

    def self.instance
      @@instance ||= new
    end

    def initialize
      @logger = Logger.new(STDOUT)
      @threads = {}
    end

    def stop(playlist)
      self.playlist = playlist
      self.channel_name = playlist.user.channel.name
      thread_alive? ? kill_thread { clear_status } : clear_status
    end

    def pause_or_play(playlist)
      self.playlist = playlist
      self.channel_name = playlist.user.channel.name
      thread_alive? ? kill_thread { save_status } : start_thread
    end

    private

    attr_reader :threads

    def start_thread
      threads[channel_name] = Thread.new do
        Thread.current['streamer'] = Streamer.new(channel_name, playlist.left_songs_urls, playlist.file_position)
        Thread.current['streamer'].start
      end
      channel_active(true)
    end

    def kill_thread
      yield
      current = @threads.delete(channel_name)
      current.kill if current
    end

    def thread_alive?
      threads[channel_name] && threads[channel_name].alive?
    end

    def save_status
      thread = threads[channel_name]['streamer']
      playlist.update(current_song: thread.current_song, file_position: thread.file_position)
    end

    def clear_status
      playlist.update(current_song: nil, file_position: 0)
      channel_active(false)
    end

    def channel_active(isActive)
      playlist.user.channel.update(active: isActive)
    end
  end
end
