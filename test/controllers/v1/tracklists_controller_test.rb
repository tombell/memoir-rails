require "test_helper"

class V1::TracklistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @headers = { "Accept" => "application/vnd.api+json" }
  end

  test "index: returns tracklists" do
    get v1_tracklists_url, headers: @headers
    assert_response :success

    json = JSON.parse(response.body)
    assert json["data"].is_a?(Array)
    assert_equal 3, json["data"].count
    assert json["data"].first["attributes"]["name"]
  end

  test "index: filters by name" do
    get v1_tracklists_url(filter: { name_eq: "Night Drive" }), headers: @headers
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal 1, json["data"].count
    assert_equal "Night Drive", json["data"].first["attributes"]["name"]
  end

  test "index: filters by date" do
    get v1_tracklists_url(filter: { date_eq: "2025-07-15" }), headers: @headers
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal 1, json["data"].count
    assert_equal "2025-07-15", json["data"].first["attributes"]["date"]
  end

  test "index: returns empty for non matching filter" do
    get v1_tracklists_url(filter: { name_eq: "Nonexistent" }), headers: @headers
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal 0, json["data"].count
  end

  test "index: paginates with page size" do
    get v1_tracklists_url(page: { size: 2 }), headers: @headers
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal 2, json["data"].count
  end

  test "index: paginates with page number" do
    get v1_tracklists_url(page: { size: 1, number: 2 }), headers: @headers
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal 1, json["data"].count
    assert_equal "Summer Vibes", json["data"].first["attributes"]["name"]
  end

  test "index: clamps page size to max" do
    get v1_tracklists_url(page: { size: 200 }), headers: @headers
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal 3, json["data"].count
  end

  test "index: handles invalid filter gracefully" do
    get v1_tracklists_url(filter: { invalid_field_eq: "value" }), headers: @headers
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal 3, json["data"].count
  end

  test "show: returns tracklist" do
    tracklist = tracklists(:tracklist_one)
    get v1_tracklist_url(tracklist), headers: @headers
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal "Night Drive", json["data"]["attributes"]["name"]
    assert_equal "2025-02-14", json["data"]["attributes"]["date"]
    assert json["data"]["relationships"]["tracklists_tracks"]
  end

  test "show: returns not found for invalid id" do
    get v1_tracklist_url(99999), headers: @headers
    assert_response :not_found
  end

  test "create: creates tracklist" do
    assert_difference("Tracklist.count") do
      post v1_tracklists_url, params: {
        data: { type: "tracklists", attributes: { name: "New Tracklist", date: "2026-01-01", artwork: "https://example.com/art.jpg", url: "https://example.com/tl" } }
      }, headers: @headers.merge("Content-Type" => "application/vnd.api+json"), as: :json
    end
    assert_response :created

    json = JSON.parse(response.body)
    assert_equal "New Tracklist", json["data"]["attributes"]["name"]
    assert_equal "2026-01-01", json["data"]["attributes"]["date"]
  end

  test "create: does not create with invalid params" do
    assert_no_difference("Tracklist.count") do
      post v1_tracklists_url, params: {
        data: { type: "tracklists", attributes: { name: "", date: "2026-01-01", artwork: "", url: "" } }
      }, headers: @headers.merge("Content-Type" => "application/vnd.api+json"), as: :json
    end
    assert_response :unprocessable_entity

    json = JSON.parse(response.body)
    assert json["errors"].present?
  end

  test "update: updates tracklist" do
    patch v1_tracklist_url(tracklists(:tracklist_one)), params: {
      data: { type: "tracklists", attributes: { name: "Updated Tracklist" } }
    }, headers: @headers.merge("Content-Type" => "application/vnd.api+json"), as: :json
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal "Updated Tracklist", json["data"]["attributes"]["name"]
  end

  test "update: does not update with invalid params" do
    patch v1_tracklist_url(tracklists(:tracklist_one)), params: {
      data: { type: "tracklists", attributes: { name: "" } }
    }, headers: @headers.merge("Content-Type" => "application/vnd.api+json"), as: :json
    assert_response :unprocessable_entity

    json = JSON.parse(response.body)
    assert json["errors"].present?
  end

  test "destroy: destroys tracklist" do
    assert_difference("Tracklist.count", -1) do
      assert_difference("TracklistsTrack.count", -2) do
        delete v1_tracklist_url(tracklists(:tracklist_one)), headers: @headers
      end
    end
    assert_response :no_content
  end

  test "destroy: does not destroy with invalid id" do
    delete v1_tracklist_url(99999), headers: @headers
    assert_response :not_found

    json = JSON.parse(response.body)
    assert_equal "Not Found", json["errors"].first["title"]
  end
end
