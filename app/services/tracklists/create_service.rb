module Tracklists
  class CreateService
    def self.call(tracklist:, tracks:)
      new(tracklist:, tracks:).call
    end

    def initialize(tracklist:, tracks:)
      @tracklist = tracklist
      @tracks = tracks
    end

    def call
      validate_tracks_presence!

      Tracklist.transaction do
        tracklist = Tracklist.create!(@tracklist)

        @tracks.each_with_index do |track_attrs, index|
          TracklistsTrack.create!(
            tracklist: tracklist,
            track: Track.create!(track_attrs),
            track_number: index + 1
          )
        end

        tracklist
      end
    end

    private

    def validate_tracks_presence!
      return if @tracks.present?

      tracklist = Tracklist.new(@tracklist)
      tracklist.errors.add(:tracks, :blank)

      raise ActiveRecord::RecordInvalid.new(tracklist)
    end
  end
end
