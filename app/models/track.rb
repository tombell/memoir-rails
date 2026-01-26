class Track < ApplicationRecord
  has_many :tracklists_tracks, dependent: :destroy
  has_many :tracklists, through: :tracklists_tracks

  validates :artist, :name, :genre, :bpm, :key, presence: true
end
