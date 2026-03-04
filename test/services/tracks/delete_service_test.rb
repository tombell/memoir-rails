require "test_helper"

class Tracks::DeleteServiceTest < ActiveSupport::TestCase
  setup do
    @track = Track.create!(
      artist: "Test Artist",
      name: "Test Track",
      genre: "Electronic",
      key: "A minor",
      bpm: 120.0
    )
  end

  test("deletes track") do
    before_count = Track.count

    deleted_track = Tracks::DeleteService.call(id: @track.id)

    assert_equal @track.id, deleted_track.id
    assert_equal before_count - 1, Track.count
  end

  test("raises when track not found") do
    assert_raises(ActiveRecord::RecordNotFound) do
      Tracks::DeleteService.call(id: -1)
    end
  end
end
