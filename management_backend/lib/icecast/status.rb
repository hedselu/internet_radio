# frozen_string_literal: true

require 'net/http'

module Icecast
  class Status
    PATH = '/status-json.xsl'.freeze

    def initialize(channel)
      @channel_path = '/' + channel
    end

    def fetch
      response = perform_request
      body = JSON.parse(response.body)
      status_resolve(body)
    end

    private

    def build_uri
      host = ENV.fetch('ICECAST_HOST')
      port = ENV.fetch('ICECAST_PORT')
      URI("http://#{host}:#{port}#{PATH}")
    end

    def perform_request
      @uri ||= build_uri
      Net::HTTP.start(uri.host, uri.port) do |http|
        request = Net::HTTP::Get.new(uri)
        http.request(request)
      end
    end

    def status_resolve(body)
      stats = { 'listeners' => 0, 'now_playing' => ''}
      root = body['icestats']['source']

      if root
        source = root.is_a?(Array) ? find_source(root) : root
        stats['listeners'] = source['listeners']
        stats['now_playing'] = source['title']
      end

      stats
    end

    def find_source(root)
      expected_listen_url = uri(channel_path)
      root.each do |source|
        return source if source['listenurl'] =~ /^#{expected_listen_url}$/
      end
    end

    private

    attr_reader :channel_path, :uri
  end
end
