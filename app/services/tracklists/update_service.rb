module Tracklists
  class UpdateService
    def self.call(id:, tracklist:)
      new(id:, tracklist:).call
    end

    def initialize(id:, tracklist:)
      @id = id
      @tracklist = tracklist
    end

    def call
      tracklist = Tracklist.find(@id)
      tracklist.update!(@tracklist)
      tracklist
    end
  end
end
