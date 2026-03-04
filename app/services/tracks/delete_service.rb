module Tracks
  class DeleteService
    def self.call(id:)
      new(id:).call
    end

    def initialize(id:)
      @id = id
    end

    def call
      track = Track.find(@id)
      track.destroy!
      track
    end
  end
end
