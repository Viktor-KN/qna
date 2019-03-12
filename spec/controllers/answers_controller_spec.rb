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
end
