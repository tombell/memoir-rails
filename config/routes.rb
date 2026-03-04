Rails.application.routes.draw do
  get "up" => "rails/health#show", :as => :rails_health_check

  namespace :v1 do
    resources :tracklists, only: %i[index show create update destroy]
    resources :tracks, only: %i[show create update destroy]
  end
end
