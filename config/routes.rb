Rails.application.routes.draw do
  root 'home#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Note to reviewer: I tend to favor header-based versioning, but I think this looks nicer for a demo :)
  namespace :api do
    namespace :v1 do
      resources :awards, only: [:index]
      resources :filers, only: [:index]
      resources :filings, only: [:index]
      resources :recipients, only: [:index]
    end
  end
end
