class TracklistsTrack < ApplicationRecord
  belongs_to :tracklist
  belongs_to :track
end
