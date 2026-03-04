module V1
  class TracksController < ApiController
    def show
      render jsonapi: Track.find(params[:id])
    end

    def create
      track = Tracks::CreateService.call(track: track_params)
      render jsonapi: track, status: :created
    rescue ActiveRecord::RecordInvalid => e
      render jsonapi_errors: e.record.errors, status: :unprocessable_entity
    end

    def update
      track = Tracks::UpdateService.call(id: params[:id], track: track_params)
      render jsonapi: track
    rescue ActiveRecord::RecordInvalid => e
      render jsonapi_errors: e.record.errors, status: :unprocessable_entity
    end

    def destroy
      Tracks::DeleteService.call(id: params[:id])
      head :no_content
    rescue ActiveRecord::RecordNotFound => e
      render jsonapi_errors: [ { title: "Not Found", detail: e.message } ], status: :not_found
    end

    private

    def track_params
      jsonapi_deserialize(params, only: %i[artist name genre bpm key])
    end
  end
end
