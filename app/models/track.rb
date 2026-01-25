class Track < ApplicationRecord
  has_many :tracklists_tracks, dependent: :destroy
  has_many :tracklists, through: :tracklists_tracks
end
