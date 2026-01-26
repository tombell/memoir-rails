require "test_helper"

class V1::TracklistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tracklist = Tracklist.create!(
      name: "First Light",
      date: Date.new(2025, 1, 10),
      artwork: "https://assets.memoir.example/tracklists/first-light.jpg",
      url: "https://memoir.example/tracklists/first-light"
    )

    @track = Track.create!(
      artist: "Aurora Lane",
      name: "Morning Signal",
      genre: "Ambient",
      key: "C minor",
      bpm: 118.0
    )

    TracklistsTrack.create!(
      tracklist: @tracklist,
      track: @track,
      track_number: 1
    )
  end

  test "index" do
    get v1_tracklists_url

    assert_response :success

    body = JSON.parse(@response.body)

    assert_equal "tracklist", body.dig("data", 0, "type")
    assert_includes body.fetch("data").map { |item| item.fetch("id") }, @tracklist.id
  end

  test "show" do
    get v1_tracklist_url(@tracklist)

    assert_response :success

    body = JSON.parse(@response.body)
    assert_equal "tracklist", body.dig("data", "type")
    assert_equal @tracklist.id, body.dig("data", "id")
  end

  test "create" do
    payload = {
      data: {
        type: "tracklist",
        attributes: {
          name: "Night Drive",
          date: "2025-02-14",
          artwork: "https://assets.memoir.example/tracklists/night-drive.jpg",
          url: "https://memoir.example/tracklists/night-drive"
        },
        relationships: {
          tracks: {
            data: [
              {
                type: "track",
                attributes: {
                  artist: "Phase Violet",
                  name: "City Glass",
                  genre: "Electronic",
                  key: "A minor",
                  bpm: 124.0
                }
              },
              {
                type: "track",
                attributes: {
                  artist: "Harbor Atlas",
                  name: "Signal Run",
                  genre: "House",
                  key: "F major",
                  bpm: 122.0
                }
              }
            ]
          }
        }
      }
    }

    before_tracklists = Tracklist.count
    before_tracks = Track.count
    before_joins = TracklistsTrack.count

    post v1_tracklists_url, params: payload

    assert_response :created

    assert_equal before_tracklists + 1, Tracklist.count
    assert_equal before_tracks + 2, Track.count
    assert_equal before_joins + 2, TracklistsTrack.count

    created_tracklist = Tracklist.order(:created_at).last
    track_numbers = created_tracklist.tracklists_tracks.order(:track_number).pluck(:track_number)

    assert_equal [ 1, 2 ], track_numbers
  end
end
