module V1
  class TrackSerializer
    include JSONAPI::Serializer

    attributes :artist, :name, :genre, :key, :bpm

    has_many :tracklists_tracks
  end
end
