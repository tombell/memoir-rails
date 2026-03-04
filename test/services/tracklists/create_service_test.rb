require "test_helper"

class Tracklists::CreateServiceTest < ActiveSupport::TestCase
  setup do
    @tracklist = {
      name: "Night Drive",
      date: Date.new(2025, 2, 14),
      artwork: "https://assets.memoir.example/tracklists/night-drive.jpg",
      url: "https://memoir.example/tracklists/night-drive"
    }
  end

  test("creates tracklist") do
    before_tracklists = Tracklist.count

    tracklist = Tracklists::CreateService.call(tracklist: @tracklist)

    assert_equal before_tracklists + 1, Tracklist.count
    assert_equal "Night Drive", tracklist.name
    assert_equal Date.new(2025, 2, 14), tracklist.date
  end

  test("raises when tracklist attributes are invalid") do
    before_tracklists = Tracklist.count

    invalid_tracklist = @tracklist.merge(name: nil)

    assert_raises(ActiveRecord::RecordInvalid) do
      Tracklists::CreateService.call(tracklist: invalid_tracklist)
    end

    assert_equal before_tracklists, Tracklist.count
  end
end
