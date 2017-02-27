def user_setup
  user = create(:user_with_channel)
  playlist = Playlist.new(name: 'nice_playlist')

  song = Song.new
  File.open(File.join(Rails.root, 'spec', 'fixtures', 'files', 'ruby_kaiser.mp3')) { |f| song.file = f }
  song.extract_info!
  song.user = user

  user.playlists << playlist
  user.playlists.first.songs << song
  user
end
