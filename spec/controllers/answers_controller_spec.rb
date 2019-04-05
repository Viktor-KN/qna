require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    before { login(user) }

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(assigns(:question)).to eq question
      end

      it 'assigns logged in user as answer author' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(assigns(:answer).author).to eq user
      end

      it 'saves a new answer for question in the database' do
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        end.to change(question.answers, :count).by(1)
      end

      it 'renders create view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        end.to_not change(Answer, :count)
      end

      it 'renders create view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    before { login(user) }

    context 'for own answer' do
      let!(:answer) { create(:answer, author: user, question: question) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: answer }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context "for other user's answer" do
      let(:another_user) { create(:user) }
      let!(:answer) { create(:answer, author: another_user, question: question) }

      it 'does not destroy the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PATCH #update' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    before { login(user) }

    context 'with valid attributes' do
      let!(:answer) { create(:answer, question: question, author: user) }

      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      let!(:answer) { create(:answer, question: question, author: user) }

      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context "for other user's answer" do
      let(:other_user) { create(:user) }
      let!(:answer) { create(:answer, question: question, author: other_user) }

      it 'does not change answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to_not eq 'new body'
      end
    end
  end

  describe 'PATCH #assign_as_best' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let!(:answer) { create(:answer, question: question) }
    let!(:reward) { create(:reward, question: question, image: png) }

    context 'as question author' do
      before do
        login(user)
        patch :assign_as_best, params: { id: answer }, format: :js
      end

      it 'changes answer best attribute value to true' do
        answer.reload

        expect(answer).to be_best
      end

      it 'assigns reward to author of best answer' do
        question.reward.reload

        expect(question.reward.recipient).to eq answer.author
      end

      it 'renders assign_as_best view' do
        expect(response).to render_template :assign_as_best
      end
    end

    context 'as not question author' do
      before do
        login(another_user)
        patch :assign_as_best, params: { id: answer }, format: :js
      end

      it 'does not change answer best attribute value' do
        answer.reload

        expect(answer).to_not be_best
      end

      it 'does not assign reward to author of best answer' do
        question.reward.reload

        expect(question.reward.recipient).to_not eq answer.author
      end

      it 'renders assign_as_best view' do
        expect(response).to render_template :assign_as_best
      end
    end
  end
end
