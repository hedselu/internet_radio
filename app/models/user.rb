class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable # , :confirmable

  include DeviseTokenAuth::Concerns::User

  has_many :playlists
  has_many :songs
  has_one :channel
end
