module Tracklists
  class CreateService
    def self.call(tracklist:)
      new(tracklist:).call
    end

    def initialize(tracklist:)
      @tracklist = tracklist
    end

    def call
      Tracklist.create!(@tracklist)
    end
  end
end
