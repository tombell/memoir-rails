class Tracklist < ApplicationRecord
  has_many :tracklists_tracks, dependent: :destroy
  has_many :tracks, through: :tracklists_tracks
end
