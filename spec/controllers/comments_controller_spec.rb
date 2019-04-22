require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  with_model :WithCommentable do
    table { |t| t.references :author, index: { name: 'author_index' } }

    model do
      include Commentable
      belongs_to :author, class_name: 'User'
    end
  end

  let(:user) { create(:user) }
  let!(:commentable) { WithCommentable.create!(author: user) }

  before do
    routes.draw do
      resources :with_commentables do
        resources :comments, shallow: true, only: %i[create]
      end
    end

    login(user)
  end

  after(:all) { Rails.application.reload_routes! }

  context 'with valid attributes' do
    it 'saves a new comment for commentable in the database' do
      expect do
        post :create, params: { with_commentable_id: commentable.id,
                                comment: { body: 'new comment' },
                                commentable_type: 'WithCommentable' }
      end.to change(Comment, :count).by(1)
    end

    it 'assigns logged in user as comment author' do
      post :create, params: { with_commentable_id: commentable.id,
                              comment: { body: 'new comment' },
                              commentable_type: 'WithCommentable' }

      expect(assigns(:commentable).comments.first.author).to eq user
    end

    it 'sets status of response as ok' do
      post :create, params: { with_commentable_id: commentable.id,
                              comment: { body: 'new comment' },
                              commentable_type: 'WithCommentable' }

      expect(response).to have_http_status :ok
    end

    it 'renders json response' do
      post :create, params: { with_commentable_id: commentable.id,
                              comment: { body: 'new comment' },
                              commentable_type: 'WithCommentable' }

      expect(response.content_type).to eq "application/json"
    end
  end

  context 'with invalid attributes' do
    it 'does not save the comment' do
      expect do
        post :create, params: { with_commentable_id: commentable.id,
                                comment: { body: '' },
                                commentable_type: 'WithCommentable' }
      end.to_not change(Comment, :count)
    end

    it 'sets status of response as unprocessable entity' do
      post :create, params: { with_commentable_id: commentable.id,
                              comment: { body: '' },
                              commentable_type: 'WithCommentable' }

      expect(response).to have_http_status :unprocessable_entity
    end

    it 'renders json response' do
      post :create, params: { with_commentable_id: commentable.id,
                              comment: { body: '' },
                              commentable_type: 'WithCommentable' }

      expect(response.content_type).to eq "application/json"
    end
  end
end
