Rails.application.routes.draw do
  concern :votable do
    member do
      post :vote_up
      post :vote_down
      delete :vote_delete
    end
  end

  concern :commentable do |options|
    resources :comments, { only: %i[create], shallow: true }.merge(options)
  end

  devise_for :users

  resources :questions do
    concerns :votable
    concerns :commentable, commentable_type: 'Question'

    resources :answers, shallow: true do
      concerns :votable
      concerns :commentable, commentable_type: 'Answer'

      patch :assign_as_best, on: :member
    end
  end

  resources :attachments, only: %i[destroy]

  resources :links, only: %i[destroy]

  resources :rewards, only: %i[index]

  root to: "questions#index"
end
