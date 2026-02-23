module V1
  class TrackSerializer
    include JSONAPI::Serializer

    attributes :artist, :name, :genre, :bpm, :key

    has_many :tracklists_tracks
  end
end
