require "test_helper"

class Tracklists::CreateServiceTest < ActiveSupport::TestCase
  setup do
    @tracklist = {
      name: "Night Drive",
      date: Date.new(2025, 2, 14),
      artwork: "https://assets.memoir.example/tracklists/night-drive.jpg",
      url: "https://memoir.example/tracklists/night-drive"
    }

    @tracks = [
      {
        artist: "Phase Violet",
        name: "City Glass",
        genre: "Electronic",
        key: "A minor",
        bpm: 124.0
      },
      {
        artist: "Harbor Atlas",
        name: "Signal Run",
        genre: "House",
        key: "F major",
        bpm: 122.0
      }
    ]
  end

  test("creates tracklist with tracks") do
    before_tracklists = Tracklist.count
    before_tracks = Track.count
    before_joins = TracklistsTrack.count

    tracklist = Tracklists::CreateService.call(
      tracklist: @tracklist,
      tracks: @tracks
    )

    assert_equal before_tracklists + 1, Tracklist.count
    assert_equal before_tracks + 2, Track.count
    assert_equal before_joins + 2, TracklistsTrack.count
    assert_equal "Night Drive", tracklist.name
    assert_equal Date.new(2025, 2, 14), tracklist.date

    track_numbers = tracklist.tracklists_tracks.order(:track_number).pluck(:track_number)
    assert_equal [ 1, 2 ], track_numbers
  end

  test("raises when tracks are missing") do
    before_tracklists = Tracklist.count
    before_tracks = Track.count
    before_joins = TracklistsTrack.count

    assert_raises(ActiveRecord::RecordInvalid) do
      Tracklists::CreateService.call(
        tracklist: @tracklist,
        tracks: []
      )
    end

    assert_equal before_tracklists, Tracklist.count
    assert_equal before_tracks, Track.count
    assert_equal before_joins, TracklistsTrack.count
  end

  test("raises when a track creation fails") do
    before_tracklists = Tracklist.count
    before_tracks = Track.count
    before_joins = TracklistsTrack.count

    assert_raises(ActiveRecord::RecordInvalid) do
      Tracklists::CreateService.call(
        tracklist: @tracklist,
        tracks: [ @tracks.first, nil ]
      )
    end

    assert_equal before_tracklists, Tracklist.count
    assert_equal before_tracks, Track.count
    assert_equal before_joins, TracklistsTrack.count
  end
end
