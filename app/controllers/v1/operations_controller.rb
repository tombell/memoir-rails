module V1
  class OperationsController < ApiController
    rescue_from ActionController::ParameterMissing, with: :render_missing_param

    def create
      validate_content_type
      operations = parse_operations
      results = process_operations(operations)
      render_success(results)
    rescue => e
      render_error(e)
    end

    private

    def validate_content_type
      expected = 'application/vnd.api+json;ext="https://jsonapi.org/ext/atomic"'
      unless request.content_type == expected
        raise ArgumentError, "Invalid content type: expected #{expected}"
      end
    end

    def parse_operations
      params.require(:atomic).require(:operations)
    end

    def process_operations(operations)
      results = []
      lid_map = {}

      ActiveRecord::Base.transaction do
        operations.each_with_index do |op, index|
          result = process_operation(op, lid_map)
          results << result
        rescue => e
          raise OperationError.new(index, e.message)
        end
      end

      results
    end

    def process_operation(op, lid_map)
      case op[:op]
      when "add"
        handle_add(op, lid_map)
      when "update"
        handle_update(op, lid_map)
      when "remove"
        handle_remove(op, lid_map)
      else
        raise ArgumentError, "Unknown operation: #{op[:op]}"
      end
    end

    def handle_add(op, lid_map)
      if op[:ref]&.[](:relationship)
        handle_add_relationship(op, lid_map)
      else
        handle_add_resource(op, lid_map)
      end
    end

    def handle_add_resource(op, lid_map)
      type = op[:data][:type]
      klass = type.singularize.classify.constantize
      attributes = jsonapi_deserialize(ActionController::Parameters.new({ data: op[:data] }), only: allowed_attributes_for(klass))
      resource = klass.create!(attributes)

      lid_map[op[:lid]] = resource if op[:lid]

      { data: serialize_resource(resource) }
    end

    def handle_add_relationship(op, lid_map)
      ref = op[:ref]
      relationship = ref[:relationship]
      parent = find_resource(ref, lid_map)

      case relationship
      when "tracks"
        tracks = op[:data].map { |item| find_resource(item.permit!.to_h.symbolize_keys, lid_map) }
        tracks.each do |track|
          TracklistsTrack.create!(tracklist: parent, track: track, track_number: parent.tracks.count + 1)
        end
      else
        raise ArgumentError, "Unsupported relationship: #{relationship}"
      end

      {}
    end

    def handle_update(op, lid_map)
      if op[:ref]&.[](:relationship)
        handle_update_relationship(op, lid_map)
      else
        handle_update_resource(op, lid_map)
      end
    end

    def handle_remove(op, lid_map)
      if op[:ref]&.[](:relationship)
        handle_remove_relationship(op, lid_map)
      else
        handle_remove_resource(op, lid_map)
      end
    end

    def handle_update_resource(op, lid_map)
      resource = find_resource(op[:ref], lid_map)
      attributes = jsonapi_deserialize(ActionController::Parameters.new({ data: op[:data] }), only: allowed_attributes_for(resource.class))
      resource.update!(attributes)

      { data: serialize_resource(resource) }
    end

    def handle_update_relationship(op, lid_map)
      ref = op[:ref]
      relationship = ref[:relationship]
      parent = find_resource(ref, lid_map)

      case relationship
      when "tracks"
        # For update, replace all tracks
        parent.tracklists_tracks.destroy_all
        tracks = op[:data].map { |item| find_resource(item.permit!.to_h.symbolize_keys, lid_map) }
        tracks.each_with_index do |track, index|
          TracklistsTrack.create!(tracklist: parent, track: track, track_number: index + 1)
        end
      else
        raise ArgumentError, "Unsupported relationship: #{relationship}"
      end

      {}
    end

    def handle_remove_resource(op, lid_map)
      resource = find_resource(op[:ref], lid_map)
      resource.destroy!

      {}
    end

    def handle_remove_relationship(op, lid_map)
      ref = op[:ref]
      relationship = ref[:relationship]
      parent = find_resource(ref, lid_map)

      case relationship
      when "tracks"
        tracks = op[:data].map { |item| find_resource(item.permit!.to_h.symbolize_keys, lid_map) }
        parent.tracks.delete(*tracks)
      else
        raise ArgumentError, "Unsupported relationship: #{relationship}"
      end

      {}
    end

    def render_success(results)
      if results.all?(&:empty?)
        head :no_content
      else
        render json: { "atomic:results" => results }, status: :ok
      end
    end

    def render_error(error)
      if error.is_a?(OperationError)
        render json: {
          errors: [ {
            status: "400",
            title: "Bad Request",
            detail: error.message,
            source: { pointer: "/atomic:operations/#{error.index}" }
          } ]
        }, status: :bad_request
      elsif error.is_a?(ArgumentError)
        render json: {
          errors: [ {
            status: "400",
            title: "Bad Request",
            detail: error.message
          } ]
        }, status: :bad_request
      else
        render json: {
          errors: [ {
            status: "500",
            title: "Internal Server Error",
            detail: error.message
          } ]
        }, status: :internal_server_error
      end
    end

    def render_missing_param(exception)
      render json: {
        errors: [ {
          status: "400",
          title: "Bad Request",
          detail: "Missing parameter: #{exception.param}"
        } ]
      }, status: :bad_request
    end

    def find_resource(ref, lid_map)
      if ref[:lid]
        lid_map[ref[:lid]] or raise ArgumentError, "Unknown LID: #{ref[:lid]}"
      elsif ref[:id]
        ref[:type].singularize.classify.constantize.find(ref[:id])
      else
        raise ArgumentError, "Invalid ref: must have id or lid"
      end
    end

    def allowed_attributes_for(klass)
      case klass.name
      when "Tracklist"
        %i[name date artwork url]
      when "Track"
        %i[artist name genre key bpm]
      else
        []
      end
    end

    def serialize_resource(resource)
      serializer_class = "V1::#{resource.class.name}Serializer".constantize
      serializer_class.new(resource).serializable_hash[:data]
    end

    class OperationError < StandardError
      attr_reader :index
      def initialize(index, message)
        @index = index
        super(message)
      end
    end
  end
end
