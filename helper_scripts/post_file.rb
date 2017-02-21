require 'rest-client'

files = ARGV.each_with_object([]) do |file, array|
  array << File.new(file, 'rb')
end

URL_SIGN_IN = 'http://localhost:3000/sign_in'.freeze
URL_SONGS = 'http://localhost:3000/songs'.freeze

RestClient.post(URL_SONGS, songs: { files: files })
