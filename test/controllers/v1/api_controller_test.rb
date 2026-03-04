require "test_helper"

class V1::ApiControllerTest < ActionController::TestCase
  tests V1::ApiController

  test "jsonapi_serializer_class returns V1 serializer for known class" do
    track = tracks(:track_one)
    serializer_class = @controller.send(:jsonapi_serializer_class, track, false)
    assert_equal "V1::TrackSerializer", serializer_class.name
  end

  test "jsonapi_serializer_class returns V1 serializer for collection" do
    tracks = Track.all
    serializer_class = @controller.send(:jsonapi_serializer_class, tracks, true)
    assert_equal "V1::TrackSerializer", serializer_class.name
  end

  test "jsonapi_serializer_class attempts fallback on NameError but may raise" do
    resource = {}
    # The method tries V1 serializer, on NameError falls back to JSONAPI::Rails.serializer_class
    # For unknown resources, both may fail, so it may raise NameError
    assert_raises NameError do
      @controller.send(:jsonapi_serializer_class, resource, false)
    end
end
end
