require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let!(:link) { create(:link, linkable: question) }

    before { login(user) }

    it 'assigns requested link to @link' do
      delete :destroy, params: { id: link }, format: :js

      expect(assigns(:link)).to eq link
    end

    it 'assigns resource to @resource' do
      delete :destroy, params: { id: link }, format: :js

      expect(assigns(:resource)).to eq question
    end

    context 'for own resource' do
      it 'destroy attached link' do
        expect do
          delete :destroy, params: { id: link }, format: :js
        end.to change(Link, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: link }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context "for other user's resource" do
      let(:another_user) { create(:user) }
      let(:question) { create(:question, author: another_user) }
      let!(:link) { create(:link, linkable: question) }

      it 'does not destroy attached link' do
        expect do
          delete :destroy, params: { id: link }, format: :js
        end.to_not change(Link, :count)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: link }, format: :js

        expect(response).to render_template :destroy
      end
    end
  end
end
