class Playlist < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :songs
  validates :name, presence: true, uniqueness: true

  def left_songs_urls
    if current_song
      applied = false
      songs.each_with_object([]) do |song, array|
        if applied || current_song.include?(song.file.path)
          array << song.file.path
          applied = true
        end
      end
    else
      songs.each_with_object([]) do |song, array|
        array << song.file.path
      end
    end
  end
end
