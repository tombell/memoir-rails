class Tracklist < ApplicationRecord
  has_many :tracklists_tracks, dependent: :destroy
  has_many :tracks, through: :tracklists_tracks

  validates :name, :date, :artwork, :url, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[name date]
  end
end
