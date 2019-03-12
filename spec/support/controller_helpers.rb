module ControllerHelpers
  def login(user)
    #user = FactoryBot.create(:user) if user.nil?
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in(user)
  end
end
