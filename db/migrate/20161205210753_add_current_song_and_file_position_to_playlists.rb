class AddCurrentSongAndFilePositionToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :file_position, :integer, default: 0
    add_column :playlists, :current_song, :string
  end
end
