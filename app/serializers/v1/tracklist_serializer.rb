module V1
  class TracklistSerializer
    include JSONAPI::Serializer

    attributes :name, :date, :artwork, :url

    has_many :tracklists_tracks
  end
end
