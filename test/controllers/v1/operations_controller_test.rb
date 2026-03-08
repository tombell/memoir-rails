require "test_helper"

class V1::OperationsControllerTest < ActionDispatch::IntegrationTest
  test "performs atomic operations successfully" do
    assert_difference([ "Track.count", "Tracklist.count" ], 1) do
      post v1_operations_url, params: {
        operations: [
          {
            op: "add",
            data: { type: "tracks", attributes: { artist: "New Artist", name: "New Song", genre: "Pop", bpm: 120, key: "C major" } }
          },
          {
            op: "add",
            data: { type: "tracklists", attributes: { name: "New Playlist", date: "2023-01-01", artwork: "artwork.jpg", url: "http://example.com" } }
          }
        ]
      }, as: :json
    end
    assert_response :success
  end

  test "rolls back on operation failure" do
    assert_no_difference([ "Track.count", "Tracklist.count" ]) do
      post v1_operations_url, params: {
        operations: [
          {
            op: "add",
            data: { type: "tracks", attributes: { artist: "New Artist", name: "New Song", genre: "Pop", bpm: 120, key: "C major" } }
          },
          {
            op: "add",
            data: { type: "tracklists", attributes: { name: "", date: "2023-01-01", artwork: "artwork.jpg", url: "http://example.com" } } # invalid name
          }
        ]
      }, as: :json
    end
    assert_response :unprocessable_entity
  end

  test "returns detailed errors for failed operations" do
    post v1_operations_url, params: {
      operations: [
        {
          op: "add",
          data: { type: "tracks", attributes: { artist: "New Artist", name: "New Song", genre: "Pop", bpm: 120, key: "C major" } }
        },
        {
          op: "update",
          ref: { id: 999, type: "tracks" },
          data: { type: "tracks", attributes: { name: "Updated Name" } }
        }
      ]
    }, as: :json
    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert json_response["errors"].present?
    assert_equal 1, json_response["errors"].first["operation"]
  end

  test "removes tracklist and deletes mappings" do
    tracklist = tracklists(:tracklist_one) # has 2 tracks
    assert_difference("Tracklist.count", -1) do
      assert_difference("TracklistsTrack.count", -2) do
        assert_no_difference("Track.count") do
          post v1_operations_url, params: {
            operations: [
              {
                op: "remove",
                ref: { id: tracklist.id, type: "tracklists" }
              }
            ]
          }, as: :json
        end
      end
    end
    assert_response :success
  end

  test "removes track and deletes mappings" do
    track = tracks(:track_one) # has 1 mapping
    assert_difference("Track.count", -1) do
      assert_difference("TracklistsTrack.count", -1) do
        post v1_operations_url, params: {
          operations: [
            {
              op: "remove",
              ref: { id: track.id, type: "tracks" }
            }
          ]
        }, as: :json
      end
    end
    assert_response :success
  end

  test "fails to remove non-existent track" do
    assert_no_difference([ "Track.count", "TracklistsTrack.count" ]) do
      post v1_operations_url, params: {
        operations: [
          {
            op: "remove",
            ref: { id: 999, type: "tracks" }
          }
        ]
      }, as: :json
    end
    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert json_response["errors"].present?
    assert_equal 0, json_response["errors"].first["operation"]
  end

  test "fails to add with invalid type" do
    assert_no_difference([ "Track.count", "Tracklist.count" ]) do
      post v1_operations_url, params: {
        operations: [
          {
            op: "add",
            data: { type: "invalid", attributes: { name: "Test" } }
          }
        ]
      }, as: :json
    end
    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert json_response["errors"].present?
    assert_equal 0, json_response["errors"].first["operation"]
  end

  test "fails to update with invalid type" do
    assert_no_difference([ "Track.count", "Tracklist.count" ]) do
      post v1_operations_url, params: {
        operations: [
          {
            op: "update",
            ref: { id: 1, type: "invalid" },
            data: { type: "invalid", attributes: { name: "Updated" } }
          }
        ]
      }, as: :json
    end
    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert json_response["errors"].present?
    assert_equal 0, json_response["errors"].first["operation"]
  end

  test "fails to remove with invalid type" do
    assert_no_difference([ "Track.count", "Tracklist.count", "TracklistsTrack.count" ]) do
      post v1_operations_url, params: {
        operations: [
          {
            op: "remove",
            ref: { id: 1, type: "invalid" }
          }
        ]
      }, as: :json
    end
    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert json_response["errors"].present?
    assert_equal 0, json_response["errors"].first["operation"]
  end

  test "updates tracklist successfully" do
    tracklist = tracklists(:tracklist_one)
    post v1_operations_url, params: {
      operations: [
        {
          op: "update",
          ref: { id: tracklist.id, type: "tracklists" },
          data: { type: "tracklists", attributes: { name: "Updated Playlist", date: "2024-12-31", artwork: "updated.jpg", url: "updated.com" } }
        }
      ]
    }, as: :json
    assert_response :success
    tracklist.reload
    assert_equal "Updated Playlist", tracklist.name
    assert_equal "2024-12-31", tracklist.date.to_s
    assert_equal "updated.jpg", tracklist.artwork
    assert_equal "updated.com", tracklist.url
  end

  test "fails validation for empty operations array" do
    post v1_operations_url, params: { operations: [] }, as: :json
    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert json_response["errors"].present?
  end

  test "fails validation for invalid operation op" do
    post v1_operations_url, params: {
      operations: [
        {
          op: "delete",
          ref: { id: 1, type: "tracks" }
        }
      ]
    }, as: :json
    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert json_response["errors"].present?
  end

  test "fails validation for non-array operations" do
    post v1_operations_url, params: { operations: "invalid" }, as: :json
    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert json_response["errors"].present?
  end
end
