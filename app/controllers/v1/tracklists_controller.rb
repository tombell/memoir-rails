module V1
  class TracklistsController < ApiController
    def index
      filtered = jsonapi_filter(Tracklist.all, %i[name date])
      tracklists = jsonapi_paginate(filtered.result)
      render jsonapi: tracklists
    end

    def show
      render jsonapi: Tracklist.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render jsonapi_errors: [ { title: "Not Found", detail: e.message } ], status: :not_found
    end

    def create
      tracklist = Tracklists::CreateService.call(tracklist: tracklist_params)

      render jsonapi: tracklist, status: :created
    rescue ActiveRecord::RecordInvalid => e
      render jsonapi_errors: e.record.errors, status: :unprocessable_entity
    end

    def update
      tracklist = Tracklists::UpdateService.call(id: params[:id], tracklist: tracklist_params)
      render jsonapi: tracklist
    rescue ActiveRecord::RecordInvalid => e
      render jsonapi_errors: e.record.errors, status: :unprocessable_entity
    rescue ActiveRecord::RecordNotFound => e
      render jsonapi_errors: [ { title: "Not Found", detail: e.message } ], status: :not_found
    end

    def destroy
      Tracklists::DeleteService.call(id: params[:id])
      head :no_content
    rescue ActiveRecord::RecordNotFound => e
      render jsonapi_errors: [ { title: "Not Found", detail: e.message } ], status: :not_found
    end

    private

    def tracklist_params
      jsonapi_deserialize(params, only: %i[name date artwork url])
    end
  end
end
