require "test_helper"

class V1::TracklistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @headers = {"Accept" => "application/vnd.api+json"}
  end

  test "get index" do
    get v1_tracklists_url, headers: @headers
    assert_response :success

    json = JSON.parse(response.body)
    assert json["data"].is_a?(Array)
    assert_equal 3, json["data"].count
    assert json["data"].first["attributes"]["name"]
  end

  test "filter by name" do
    get v1_tracklists_url(filter: {name_eq: "Night Drive"}), headers: @headers
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal 1, json["data"].count
    assert_equal "Night Drive", json["data"].first["attributes"]["name"]
  end

  test "filter by date" do
    get v1_tracklists_url(filter: {date_eq: "2025-07-15"}), headers: @headers
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal 1, json["data"].count
    assert_equal "2025-07-15", json["data"].first["attributes"]["date"]
  end

  test "return empty results for non-matching filter" do
    get v1_tracklists_url(filter: {name_eq: "Nonexistent"}), headers: @headers
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal 0, json["data"].count
  end

  test "paginate with page size" do
    get v1_tracklists_url(page: {size: 2}), headers: @headers
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal 2, json["data"].count
  end

  test "paginate with page number" do
    get v1_tracklists_url(page: {size: 1, number: 2}), headers: @headers
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal 1, json["data"].count
    assert_equal "Summer Vibes", json["data"].first["attributes"]["name"]
  end

  test "clamp page size to max" do
    get v1_tracklists_url(page: {size: 200}), headers: @headers
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal 3, json["data"].count
  end

  test "show tracklist" do
    tracklist = tracklists(:tracklist_one)
    get v1_tracklist_url(tracklist), headers: @headers
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal "Night Drive", json["data"]["attributes"]["name"]
    assert_equal "2025-02-14", json["data"]["attributes"]["date"]
    assert json["data"]["relationships"]["tracklists_tracks"]
  end

  test "return 404 for invalid id" do
    get v1_tracklist_url(99999), headers: @headers
    assert_response :not_found
  end

  test "handle invalid filter parameter gracefully" do
    get v1_tracklists_url(filter: {invalid_field_eq: "value"}), headers: @headers
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal 3, json["data"].count
  end
end
