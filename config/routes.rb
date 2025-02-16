Rails.application.routes.draw do
  root "static_pages#home"
  devise_for :users, controllers: {
    registrations: "users/registrations",
    omniauth_callbacks: "users/omniauth_callbacks",
    sessions: "users/sessions"
  }

  resources :shops do
    resources :reviews, only: %i[new create show edit update destroy], shallow: true
    collection do
      get "search"
      get "map"
      get "list"
      get "bookmarks"
    end
  end

  resource :profile, only: %i[show edit update]

  resources :shop_bookmarks, only: %i[create destroy]

  resources :diagnoses do
    collection do
      get "start", to: "diagnoses#start"
      get "question/:id", to: "diagnoses#show_question", as: "question"
      post "answer", to: "diagnoses#answer_question"
      get "result", to: "diagnoses#result"
    end
  end

  get "privacy", to: "static_pages#privacy", as: "privacy_policy"

  get "terms", to: "static_pages#terms", as: "terms"


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
