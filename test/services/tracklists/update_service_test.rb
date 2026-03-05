require "test_helper"

class Tracklists::UpdateServiceTest < ActiveSupport::TestCase
  setup do
    @tracklist = Tracklist.create!(
      name: "Original Tracklist",
      date: Date.today,
      artwork: "https://example.com/artwork.jpg",
      url: "https://example.com/tracklist"
    )
    @updated_attrs = {
      name: "Updated Tracklist",
      date: Date.tomorrow,
      artwork: "https://example.com/updated.jpg",
      url: "https://example.com/updated"
    }
  end

  test("updates tracklist") do
    updated_tracklist = Tracklists::UpdateService.call(
      id: @tracklist.id,
      tracklist: @updated_attrs
    )

    assert_equal @tracklist.id, updated_tracklist.id
    assert_equal "Updated Tracklist", updated_tracklist.name
    assert_equal Date.tomorrow, updated_tracklist.date
  end

  test("raises when tracklist not found") do
    assert_raises(ActiveRecord::RecordNotFound) do
      Tracklists::UpdateService.call(
        id: -1,
        tracklist: @updated_attrs
      )
    end
  end

  test("raises when tracklist attributes are invalid") do
    invalid_attrs = @updated_attrs.merge(name: nil)

    assert_raises(ActiveRecord::RecordInvalid) do
      Tracklists::UpdateService.call(
        id: @tracklist.id,
        tracklist: invalid_attrs
      )
    end
  end
end
