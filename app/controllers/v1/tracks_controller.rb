module V1
  class TracksController < ApiController
    def show
      render jsonapi: Track.find(params[:id])
    end

    def create
      track = Track.new(track_params)

      if track.save
        render jsonapi: track, status: :created
      else
        render jsonapi_errors: track.errors, status: :unprocessable_entity
      end
    end

    private

    def track_params
      jsonapi_deserialize(params, only: %i[artist name genre bpm key])
    end
  end
end
