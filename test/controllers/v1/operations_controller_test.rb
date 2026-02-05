require "test_helper"

class V1::OperationsControllerTest < ActionDispatch::IntegrationTest
  test("bulk create tracklist with tracks") do
    payload = {
      atomic: {
        operations: [
          {
            op: "add",
            lid: "tracklist-1",
            data: {
              type: "tracklists",
              attributes: {
                name: "Atomic Test",
                date: "2025-01-01",
                artwork: "https://example.com/artwork.jpg",
                url: "https://example.com/tracklist"
              }
            }
          },
          {
            op: "add",
            lid: "track-1",
            data: {
              type: "tracks",
              attributes: {
                artist: "Test Artist",
                name: "Test Track",
                genre: "Test Genre",
                key: "C major",
                bpm: 120.0
              }
            }
          },
          {
            op: "add",
            ref: {
              lid: "tracklist-1",
              relationship: "tracks"
            },
            data: [
              { type: "tracks", lid: "track-1" }
            ]
          }
        ]
      }
    }

    before_counts = [ Tracklist.count, Track.count, TracklistsTrack.count ]

    post v1_operations_url, params: payload.to_json, headers: { "Content-Type" => 'application/vnd.api+json;ext="https://jsonapi.org/ext/atomic"' }

    assert_response :success

    body = JSON.parse(@response.body)

    assert_equal before_counts[0] + 1, Tracklist.count
    assert_equal before_counts[1] + 1, Track.count
    assert_equal before_counts[2] + 1, TracklistsTrack.count

    assert_equal 3, body["atomic:results"].size
    assert body["atomic:results"][0]["data"]
    assert body["atomic:results"][1]["data"]
    assert_empty body["atomic:results"][2]
  end

  test("failure rolls back all operations") do
    payload = {
      atomic: {
        operations: [
          {
            op: "add",
            data: {
              type: "tracklists",
              attributes: {
                name: "Valid",
                date: "2025-01-01",
                artwork: "https://example.com/artwork.jpg",
                url: "https://example.com/tracklist"
              }
            }
          },
          {
            op: "add",
            data: {
              type: "tracklists",
              attributes: {
                name: "Invalid",
                date: "invalid-date",  # invalid
                artwork: "https://example.com/artwork.jpg",
                url: "https://example.com/tracklist"
              }
            }
          }
        ]
      }
    }

    before_count = Tracklist.count

    post v1_operations_url, params: payload.to_json, headers: { "Content-Type" => 'application/vnd.api+json;ext="https://jsonapi.org/ext/atomic"' }

    assert_response :bad_request

    body = JSON.parse(@response.body)

    assert_equal before_count, Tracklist.count  # no change

    assert body["errors"]
    assert_equal "/atomic:operations/1", body["errors"][0]["source"]["pointer"]
  end

  test("invalid content type") do
    post v1_operations_url, params: {}, headers: { "Content-Type" => "application/json" }

    assert_response :bad_request
  end
end
