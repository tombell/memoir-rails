module V1
  class TracklistsTrackSerializer
    include JSONAPI::Serializer

    attributes :track_number

    belongs_to :track
    belongs_to :tracklist
  end
end
