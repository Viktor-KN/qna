require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    let (:user) { create(:user) }
    let(:question) { create(:question, author: user) }

    before { login(user) }

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(assigns(:question)).to eq question
      end

      it 'assigns logged in user as answer author' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(assigns(:answer).author).to eq user
      end

      it 'saves a new answer for question in the database' do
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer) }
        end.to change(question.answers, :count).by(1)
      end

      it 'redirects to @answer.question show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to assigns(:answer).question
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        end.to_not change(Answer, :count)
      end

      it 're-renders @answer.question show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }

    before { login(user) }

    let(:question) { create(:question) }

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
end
