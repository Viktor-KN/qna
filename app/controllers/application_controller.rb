class ApplicationController < ActionController::Base
  after_action :clear_xhr_flash

  private

  def clear_xhr_flash
    flash.discard if request.xhr?
  end
end
