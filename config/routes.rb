Rails.application.routes.draw do
  root "static_pages#home"
  devise_for :users, controllers: {
    registrations: "users/registrations"
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

  resources :shop_bookmarks, only: %i[create destroy]

  resources :diagnoses do
    collection do
      get 'start', to: 'diagnoses#start' # 診断ページTOP
      get 'question/:id', to: 'diagnoses#show_question', as: 'question' # 質問を表示するためのアクション。
      post 'answer', to: 'diagnoses#answer_question' # ユーザーが質問に対して選択した回答を送信するためのアクション
      get 'result', to: 'diagnoses#result' # ユーザーの診断結果を表示するためのアクション
    end
  end


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
