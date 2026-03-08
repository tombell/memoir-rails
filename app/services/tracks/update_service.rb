module Tracks
  class UpdateService
    def self.call(id:, track:)
      new(id:, track:).call
    end

    def initialize(id:, track:)
      @id = id
      @track = track
    end

    def call
      track = Track.find(@id)
      track.update!(@track)
      track
    end
  end
end
