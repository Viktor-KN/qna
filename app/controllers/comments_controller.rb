class CommentsController < ApplicationController
  before_action :find_commentable, only: %i[create]

  def create
    comment = @commentable.comments.new(comment_params)
    comment.author = current_user

    if comment.save
      render json: { commentable: commentable_css_name, data: comment, message: 'Comment successfully added' }
    else
      render json: { commentable: commentable_css_name, errors: comment.errors.full_messages,
                     message: "#{view_context.pluralize(comment.errors.count, 'error')} detected" },
             status: :unprocessable_entity
    end
  end

  private

  def find_commentable
    commentable_id = params["#{params[:commentable_type].underscore}_id"]
    @commentable = params[:commentable_type].constantize.find(commentable_id)
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def commentable_css_name
    "#{params[:commentable_type].downcase.dasherize}-#{@commentable.id}"
  end
end
