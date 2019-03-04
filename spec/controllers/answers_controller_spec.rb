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
end
