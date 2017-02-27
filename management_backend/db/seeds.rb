user = User.create(email: 'sample@gmail.com', password: 'password123', password_confirmation: 'password123')
user.create_channel(name: 'sample_channel')
user.playlists << Playlist.new(name: 'sample_playlist')
song = Song.new(user: user)
File.open(Rails.root.to_s + '/public/uploads/songs/seeds/ruby_kaiser.mp3') do |f|
  song.file = f
end
song.extract_info!
puts song.inspect
user.playlists.first.songs << song
