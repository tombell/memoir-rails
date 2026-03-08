require "test_helper"

class Tracks::UpdateServiceTest < ActiveSupport::TestCase
  setup do
    @track = Track.create!(
      artist: "Original Artist",
      name: "Original Track",
      genre: "Electronic",
      key: "A minor",
      bpm: 120.0
    )
    @updated_attrs = {
      artist: "Updated Artist",
      name: "Updated Track",
      genre: "House",
      key: "F major",
      bpm: 125.0
    }
  end

  test("updates track") do
    updated_track = Tracks::UpdateService.call(
      id: @track.id,
      track: @updated_attrs
    )

    assert_equal @track.id, updated_track.id
    assert_equal "Updated Artist", updated_track.artist
    assert_equal "Updated Track", updated_track.name
    assert_equal 125.0, updated_track.bpm
  end

  test("raises when track not found") do
    assert_raises(ActiveRecord::RecordNotFound) do
      Tracks::UpdateService.call(
        id: -1,
        track: @updated_attrs
      )
    end
  end

  test("raises when track attributes are invalid") do
    invalid_attrs = @updated_attrs.merge(name: nil)

    assert_raises(ActiveRecord::RecordInvalid) do
      Tracks::UpdateService.call(
        id: @track.id,
        track: invalid_attrs
      )
    end
  end
end
