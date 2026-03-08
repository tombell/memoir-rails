require "test_helper"

class Tracks::CreateServiceTest < ActiveSupport::TestCase
  setup do
    @track_attrs = {
      artist: "Test Artist",
      name: "Test Track",
      genre: "Electronic",
      key: "A minor",
      bpm: 120.0
    }
  end

  test("creates track") do
    before_count = Track.count

    track = Tracks::CreateService.call(track: @track_attrs)

    assert_equal before_count + 1, Track.count
    assert_equal "Test Artist", track.artist
    assert_equal "Test Track", track.name
  end

  test("raises when track attributes are invalid") do
    before_count = Track.count

    invalid_attrs = @track_attrs.merge(name: nil)

    assert_raises(ActiveRecord::RecordInvalid) do
      Tracks::CreateService.call(track: invalid_attrs)
    end

    assert_equal before_count, Track.count
  end
end
