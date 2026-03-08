module V1
  class ApiController < ApplicationController
    include JSONAPI::Errors
    include JSONAPI::Deserialization
    include JSONAPI::Fetching
    include JSONAPI::Filtering
    include JSONAPI::Pagination
    include JsonApiPagination

    private
  end
end
