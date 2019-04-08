class AttachmentsController < ApplicationController
  before_action :find_attachment, only: %i[destroy]

  def destroy
    @resource = @attachment.record
    if current_user.author_of?(@resource)
      @attachment.purge
      flash.now.notice = 'File successfully deleted'
    else
      flash.now.alert = "You don't have permission to do that"
    end
  end

  private

  def find_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end
end
