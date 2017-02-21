# frozen_string_literal: true

class Song < ActiveRecord::Base
  has_and_belongs_to_many :playlists
  belongs_to :user
  mount_uploader :file, SongUploader

  validates :title, presence: true

  before_validation :extract_info!

  UNKNOWN_AUTHOR = 'unknown'.freeze

  def extract_info!
    Mp3Info.open(file.path) do |song|
      self.title = song.tag.title
      self.author = song.tag.artist || UNKNOWN_AUTHOR
    end
  end
end
