Rails.application.routes.draw do
  get "up" => "rails/health#show", :as => :rails_health_check

  namespace :v1 do
    resources :tracklists, only: %i[index show]
    resources :tracks, only: %i[show create]
  end
end
