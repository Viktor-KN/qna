require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:question) { create(:question, :with_files, author: user) }
    let!(:attachment) { question.files.first }

    before { login(user) }

    it 'assigns requested attachment to @attachment' do
      delete :destroy, params: { id: attachment }, format: :js

      expect(assigns(:attachment)).to eq attachment
    end

    it 'assigns resource to @resource' do
      delete :destroy, params: { id: attachment }, format: :js

      expect(assigns(:resource)).to eq question
    end

    context 'for own resource' do
      it 'purges attached file' do
        expect do
          delete :destroy, params: { id: attachment }, format: :js
        end.to change(ActiveStorage::Attachment, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: attachment }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context "for other user's resource" do
      let(:another_user) { create(:user) }
      let!(:question) { create(:question, :with_files, author: another_user) }

      it 'does not purge attached file' do
        expect do
          delete :destroy, params: { id: attachment }, format: :js
        end.to_not change(ActiveStorage::Attachment, :count)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: attachment }, format: :js

        expect(response).to render_template :destroy
      end
    end
  end
end
