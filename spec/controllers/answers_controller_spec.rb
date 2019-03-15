require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  before { login(user) }

  describe 'POST #create' do
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
    context 'for own answer' do
      let!(:answer) { create(:answer, author: user, question: question) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question show view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    context "for somebody's answer" do
      let(:another_user) { create(:user) }
      let!(:answer) { create(:answer, author: another_user, question: question) }

      it 'does not destroy the answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'redirects to question show view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'PATCH #update' do
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
end
