require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'GET #new' do
    let(:question) { create(:question) }

    before { get :new, params: { question_id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns @answer.question to be a question' do
      expect(assigns(:answer).question).to eq question
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let(:question) { create(:question) }

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

      it 're-renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template :new
      end
    end
  end
end
