module V1
  class TracklistsController < ApiController
    def index
      filtered = jsonapi_filter(Tracklist.all, %i[name date])
      tracklists = jsonapi_paginate(filtered.result)
      render jsonapi: tracklists
    end

    def show
      render jsonapi: Tracklist.find(params[:id])
    end
  end
end
