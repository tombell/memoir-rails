require "test_helper"

class V1::TracksControllerTest < ActionDispatch::IntegrationTest
  test "show: returns track" do
    get v1_track_url(tracks(:track_one))
    assert_response :success
  end

  test "show: returns not found for invalid id" do
    get v1_track_url(999)
    assert_response :not_found
  end

  test "create: creates track" do
    assert_difference("Track.count") do
      post v1_tracks_url, params: { data: { type: "tracks", attributes: { artist: "New Artist", name: "New Song", genre: "Pop", bpm: 120, key: "C major" } } }, as: :json
    end
    assert_response :created
  end

  test "create: does not create with invalid params" do
    assert_no_difference("Track.count") do
      post v1_tracks_url, params: { data: { type: "tracks", attributes: { artist: "", name: "", genre: "Pop", bpm: 120, key: "C major" } } }, as: :json
    end
    assert_response :unprocessable_entity
  end

  test "update: updates track" do
    patch v1_track_url(tracks(:track_one)), params: { data: { type: "tracks", attributes: { name: "Updated Song" } } }, as: :json
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal "Updated Song", json["data"]["attributes"]["name"]
  end

  test "update: does not update with invalid params" do
    patch v1_track_url(tracks(:track_one)), params: { data: { type: "tracks", attributes: { name: "" } } }, as: :json
    assert_response :unprocessable_entity

    json = JSON.parse(response.body)
    assert json["errors"].present?
  end

  test "destroy: destroys track" do
    assert_difference("Track.count", -1) do
      delete v1_track_url(tracks(:track_one))
    end
    assert_response :no_content
  end

  test "destroy: does not destroy with invalid id" do
    delete v1_track_url(999)
    assert_response :not_found

    json = JSON.parse(response.body)
    assert_equal "Not Found", json["errors"].first["title"]
  end
end
