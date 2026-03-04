module Tracklists
  class DeleteService
    def self.call(id:)
      new(id:).call
    end

    def initialize(id:)
      @id = id
    end

    def call
      tracklist = Tracklist.find(@id)
      tracklist.destroy!
      tracklist
    end
  end
end
