class LinksController < ApplicationController
  before_action :authenticate_user!
  before_action :find_link, only: %i[destroy]

  def destroy
    @resource = @link.linkable
    if current_user.author_of?(@resource)
      @link.destroy
      flash.now.notice = 'Link successfully deleted'
    else
      flash.now.alert = "You don't have permission to do that"
    end
  end

  private

  def find_link
    @link = Link.find(params[:id])
  end
end
