require "test_helper"

class Tracklists::DeleteServiceTest < ActiveSupport::TestCase
  setup do
    @tracklist = Tracklist.create!(
      name: "Test Tracklist",
      date: Date.today,
      artwork: "https://example.com/artwork.jpg",
      url: "https://example.com/tracklist"
    )
  end

  test("deletes tracklist") do
    before_count = Tracklist.count

    deleted_tracklist = Tracklists::DeleteService.call(id: @tracklist.id)

    assert_equal @tracklist.id, deleted_tracklist.id
    assert_equal before_count - 1, Tracklist.count
  end

  test("raises when tracklist not found") do
    assert_raises(ActiveRecord::RecordNotFound) do
      Tracklists::DeleteService.call(id: -1)
    end
  end
end
