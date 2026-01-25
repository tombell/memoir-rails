module V1
  class ApiController < ApplicationController
    include JSONAPI::Errors
    include JSONAPI::Fetching
    include JSONAPI::Pagination

    MIN_PER_PAGE = 1
    MAX_PER_PAGE = 100

    private

    def jsonapi_serializer_class(resource, is_collection)
      resource_class = if is_collection
        resource.respond_to?(:klass) ? resource.klass : resource.first&.class
      else
        resource.class
      end

      "V1::#{resource_class.name}Serializer".constantize
    rescue NameError
      JSONAPI::Rails.serializer_class(resource, is_collection)
    end

    def jsonapi_page_size(pagination_params)
      per_page = pagination_params[:size].to_f.to_i
      per_page = MAX_PER_PAGE if per_page > MAX_PER_PAGE || per_page < MIN_PER_PAGE
      per_page
    end

    def jsonapi_meta(resources)
      pagination = jsonapi_pagination_meta(resources)

      meta = {}
      meta.merge!({ pagination: }) if pagination.present?
      meta
    end
  end
end
