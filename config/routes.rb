Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    resources :answers, shallow: true do
      patch :assign_as_best, on: :member
    end
  end

  resources :attachments, only: %i[destroy]

  resources :links, only: %i[destroy]

  resources :rewards, only: %i[index]

  root to: "questions#index"
end
