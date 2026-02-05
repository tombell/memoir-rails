module V1
  class TracklistsController < ApiController
    FILTERABLE_FIELDS = %i[name date]

    def index
      jsonapi_filter Tracklist.all, FILTERABLE_FIELDS do |filtered|
        jsonapi_paginate filtered.result  do |paginated|
          render jsonapi: paginated
        end
      end
    end

    def show
      render jsonapi: Tracklist.find(params[:id])
    end

    def create
      tracklist = Tracklist.transaction do
        created_tracklist = Tracklist.create!(tracklist_params)

        build_tracks.each_with_index do |track, index|
          TracklistsTrack.create!(
            tracklist: created_tracklist,
            track: track,
            track_number: index + 1
          )
        end

        created_tracklist
      end

      render(jsonapi: tracklist, status: :created)
    end

    private

    def tracklist_params
      jsonapi_deserialize(params, only: %i[name date artwork url])
    end

    def track_params
      params
        .require(:data)
        .require(:relationships)
        .require(:tracks)
        .require(:data)
    end

    def build_tracks
      track_params.map do |item|
        Track.create!(
          item.fetch(:attributes, {}).permit(:artist, :name, :genre, :key, :bpm)
        )
      end
    end
  end
end
