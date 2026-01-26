module V1
  class TracklistsController < ApiController
    FILTERABLE_FIELDS = %i[name date]

    def index
      jsonapi_filter(Tracklist.all, FILTERABLE_FIELDS) do |filtered|
        jsonapi_paginate(filtered.result) do |paginated|
          render jsonapi: paginated
        end
      end
    end

    def show
      render jsonapi: Tracklist.find(params[:id])
    end
  end
end
