require 'shout'

module Channels
  class Streamer
    BLOCKSIZE = 4096

    attr_reader :channel_name, :songs, :logger
    attr_accessor :file_position, :current_song

    def initialize(channel_name, songs_urls, file_position)
      @logger = Logger.new(STDOUT)
      @channel_name = channel_name
      @songs = songs_urls
      @file_position = file_position
    end

    def start
      connect
      play_playlist
    end

    private

    def play_playlist
      songs.each do |song_url|
        self.current_song = song_url
        play_song(song_url)
      end
    end

    def play_song(song_url)
      File.open(song_url) do |file|
        meta = ShoutMetadata.new
        meta.add('title', 'provided_title')
        @stream.metadata = meta

        file.seek(BLOCKSIZE * file_position)

        while data = file.read(BLOCKSIZE)
          @file_position += 1
          @stream.send(data)
          @stream.sync
        end
      end
    end

    def connect
      @stream = ::Shout.new
      @stream.mount = channel_name
      @stream.port = ENV.fetch('ICECAST_PORT').to_i
      @stream.host = ENV.fetch('ICECAST_HOST')
      @stream.user = ENV.fetch('ICECAST_USER')
      @stream.pass = ENV.fetch('ICECAST_PASSWORD')
      @stream.format = Shout::MP3
      @stream.connect
    end
  end
end
