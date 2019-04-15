Rails.application.routes.draw do
  concern :votable do
    member do
      post :vote_up
      post :vote_down
      delete :vote_delete
    end
  end

  devise_for :users

  resources :questions, concerns: [:votable] do
    resources :answers, concerns: [:votable], shallow: true do
      patch :assign_as_best, on: :member
    end
  end

  resources :attachments, only: %i[destroy]

  resources :links, only: %i[destroy]

  resources :rewards, only: %i[index]

  root to: "questions#index"
end
