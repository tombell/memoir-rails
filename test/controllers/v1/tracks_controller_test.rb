require "test_helper"

class V1::TracksControllerTest < ActionDispatch::IntegrationTest
  test "shows track" do
    get v1_track_url(tracks(:track_one))
    assert_response :success
  end

  test "returns not found for invalid id" do
    get v1_track_url(999)
    assert_response :not_found
  end

  test "creates track" do
    assert_difference("Track.count") do
      post v1_tracks_url, params: {data: {type: "tracks", attributes: {artist: "New Artist", name: "New Song", genre: "Pop", bpm: 120, key: "C major"}}}, as: :json
    end
    assert_response :created
  end

  test "does not create track with invalid params" do
    assert_no_difference("Track.count") do
      post v1_tracks_url, params: {data: {type: "tracks", attributes: {artist: "", name: "", genre: "Pop", bpm: 120, key: "C major"}}}, as: :json
    end
    assert_response :unprocessable_entity
  end
end
