module V1
  class OperationsController < ApiController
    def create
      operations = params.require(:operations)

      begin
        validate_operations!(operations)
      rescue ArgumentError => e
        render json: { errors: [ { code: "validation_error", title: "Validation Error", detail: e.message } ] }, status: :unprocessable_entity
        return
      end

      results = []
      errors = []

      ActiveRecord::Base.transaction do
        operations.each_with_index do |operation, index|
          begin
            result = process_operation(operation)
            results << { data: result }
          rescue StandardError => e
            errors << {
              operation: index,
              code: "operation_failed",
              title: "Operation Failed",
              detail: e.message,
              source: { operation: index }
            }
            raise ActiveRecord::Rollback
          end
        end
      end

      if errors.empty?
        render json: { data: results }, status: :ok
      else
        render json: { errors: errors }, status: :unprocessable_entity
      end
    end

    private

    def validate_operations!(operations)
      unless operations.is_a?(Array) && operations.present?
        raise ArgumentError, "operations must be a non-empty array"
      end

      operations.each do |op|
        unless op["op"].in?([ "add", "update", "remove" ])
          raise ArgumentError, "invalid operation: #{op['op']}"
        end
      end
    end

    def process_operation(operation)
      case operation["op"]
      when "add"
        process_add_operation(operation)
      when "update"
        process_update_operation(operation)
      when "remove"
        process_remove_operation(operation)
      end
    end

    def process_add_operation(operation)
      data = operation["data"]
      type = data["type"]

      case type
      when "tracks"
        track_params = jsonapi_deserialize({ "data" => data }, only: %i[artist name genre bpm key])
        Tracks::CreateService.call(track: track_params)
      when "tracklists"
        tracklist_params = jsonapi_deserialize({ "data" => data }, only: %i[name date artwork url])
        Tracklists::CreateService.call(tracklist: tracklist_params)
      else
        raise ArgumentError, "unsupported type: #{type}"
      end
    end

    def process_update_operation(operation)
      ref = operation["ref"]
      data = operation["data"]
      type = data["type"]
      id = ref["id"]

      case type
      when "tracks"
        track_params = jsonapi_deserialize({ "data" => data }, only: %i[artist name genre bpm key])
        Tracks::UpdateService.call(id: id, track: track_params)
      when "tracklists"
        tracklist_params = jsonapi_deserialize({ "data" => data }, only: %i[name date artwork url])
        Tracklists::UpdateService.call(id: id, tracklist: tracklist_params)
      else
        raise ArgumentError, "unsupported type: #{type}"
      end
    end

    def process_remove_operation(operation)
      ref = operation["ref"]
      type = ref["type"]
      id = ref["id"]

      case type
      when "tracks"
        Tracks::DeleteService.call(id: id)
      when "tracklists"
        Tracklists::DeleteService.call(id: id)
      else
        raise ArgumentError, "unsupported type: #{type}"
      end
    end
  end
end
