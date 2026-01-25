module V1
  class TracklistsController < ApiController
    def index
      jsonapi_paginate(Tracklist.all) do |paginated|
        render jsonapi: paginated
      end
    end

    def show
      render jsonapi: Tracklist.find(params[:id])
    end
  end
end
