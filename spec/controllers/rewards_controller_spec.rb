require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  describe 'GET #index' do
    let(:user) { create(:user) }
    let!(:rewards) { create_list(:reward, 3, recipient: user, image: png) }

    before do
      login(user)
      get :index
    end

    it 'populates an array of user rewards' do
      expect(assigns(:rewards)).to match_array(user.rewards)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
