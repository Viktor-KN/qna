class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :clear_gon_params

  private

  def clear_gon_params
    gon.clear
  end
end
