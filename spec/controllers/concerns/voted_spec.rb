require 'rails_helper'

class WithVotablesController < ApplicationController
  include Voted
end

RSpec.describe WithVotablesController, type: :controller do
  with_model :WithVotable do
    table { |t| t.references :author, index: { name: 'author_index' } }

    model do
      include Votable
      belongs_to :author, class_name: 'User'
    end
  end

  let(:user) { create(:user) }

  before do
    routes.draw do
      resources :with_votables do
        member do
          post :vote_up
          post :vote_down
          delete :vote_delete
        end
      end
    end
    login(user)
  end

  after(:all) { Rails.application.reload_routes! }

  %w(vote_up vote_down).each do |action|
    describe "##{action}" do
      context 'for own votable' do
        let!(:votable) { WithVotable.create!(author: user) }

        it "doesn't create new vote" do
          expect { post action, params: { id: votable.id } }.to_not change(Vote, :count)
        end

        it 'sets status of answer as forbidden' do
          post action, params: { id: votable.id }

          expect(response).to have_http_status :forbidden
        end

        it 'renders json response' do
          post action, params: { id: votable.id }

          expect(response.content_type).to eq "application/json"
        end
      end

      context "for other user's votable" do
        let(:other_user) { create(:user) }
        let!(:votable) { WithVotable.create!(author: other_user) }

        context 'when user already have vote on this votable' do
          let!(:vote) { create(:vote, user: user, votable: votable) }

          it "doesn't create new vote" do
            expect { post action, params: { id: votable.id } }.to_not change(Vote, :count)
          end

          it 'sets status of answer as conflict' do
            post action, params: { id: votable.id }

            expect(response).to have_http_status :conflict
          end

          it 'renders json response' do
            post action, params: { id: votable.id }

            expect(response.content_type).to eq "application/json"
          end
        end

        context "when user don't have vote on this votable" do
          it "create new vote" do
            expect { post action, params: { id: votable.id } }.to change(Vote, :count).by(1)
          end

          it 'sets status of answer as ok' do
            post action, params: { id: votable.id }

            expect(response).to have_http_status :ok
          end

          it 'renders json response' do
            post action, params: { id: votable.id }

            expect(response.content_type).to eq "application/json"
          end
        end
      end
    end
  end

  describe '#vote_delete' do
    let(:other_user) { create(:user) }
    let!(:votable) { WithVotable.create!(author: other_user) }

    context "when user don't have vote on this votable" do
      let!(:vote) { create(:vote, user: other_user, votable: votable) }

      it "doesn't delete vote" do
        expect { delete 'vote_delete', params: { id: votable.id } }.to_not change(Vote, :count)
      end

      it 'sets status of answer as not found' do
        delete 'vote_delete', params: { id: votable.id }

        expect(response).to have_http_status :not_found
      end

      it 'renders json response' do
        delete 'vote_delete', params: { id: votable.id }

        expect(response.content_type).to eq "application/json"
      end
    end

    context "when user have vote on this votable" do
      let!(:vote) { create(:vote, user: user, votable: votable) }

      it "deletes vote" do
        expect { delete 'vote_delete', params: { id: votable.id } }.to change(Vote, :count).by(-1)
      end

      it 'sets status of answer as ok' do
        delete 'vote_delete', params: { id: votable.id }

        expect(response).to have_http_status :ok
      end

      it 'renders json response' do
        delete 'vote_delete', params: { id: votable.id }

        expect(response.content_type).to eq "application/json"
      end
    end
  end
end
