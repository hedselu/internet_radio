require 'rest-client'

URL = 'http://localhost:3000/player'.freeze
RestClient.post(URL, {})
