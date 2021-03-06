require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }

    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns @answer.question to be a question' do
      expect(assigns(:answer).question).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    let(:user) { create(:user) }

    before do
      login(user)
      get :new
    end

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns logged in user as question author' do
      expect(assigns(:question).author).to eq user
    end

    it 'builds new reward for question' do
      expect(assigns(:question).reward).to be_a_new(Reward)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }

    before { login(user) }

    context 'with valid attributes' do
      it 'assigns logged in user as question author' do
        post :create, params: { question: attributes_for(:question) }
        expect(assigns(:question).author).to eq user
      end

      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 'builds new reward for question' do
        post :create, params: { question: attributes_for(:question, :invalid) }

        expect(assigns(:question).reward).to be_a_new(Reward)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }

    before { login(user) }

    context 'for own question' do
      let!(:question) { create(:question, author: user) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context "for other user's question" do
      let(:another_user) { create(:user) }

      let!(:question) { create(:question, author: another_user) }

      it 'does not destroy the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to question show view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'PATCH #update' do
    let(:user) { create(:user) }

    before { login(user) }

    context 'with valid attributes' do
      let!(:question) { create(:question, author: user) }

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { body: 'new body' } }, format: :js
        question.reload
        expect(question.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: question, question: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      let!(:question) { create(:question, author: user) }

      it 'does not change question attributes' do
        expect do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        end.to_not change(question, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context "for other user's question" do
      let(:other_user) { create(:user) }
      let!(:other_question) { create(:question, author: other_user) }

      it 'does not change question attributes' do
        patch :update, params: { id: other_question, question: { body: 'new body' } }, format: :js
        other_question.reload
        expect(other_question.body).to_not eq 'new body'
      end
    end
  end
end
