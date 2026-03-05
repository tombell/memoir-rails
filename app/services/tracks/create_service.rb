module Tracks
  class CreateService
    def self.call(track:)
      new(track:).call
    end

    def initialize(track:)
      @track = track
    end

    def call
      Track.create!(@track)
    end
  end
end
