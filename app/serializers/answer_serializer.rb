class AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :body, :question_id, :author_id, :best, :files, :created_at, :updated_at

  has_many :links

  def files
    return [] unless object.files.attachments

    object.files.map do |file|
      { name: file.filename.to_s, path: rails_blob_path(file, only_path: true) }
    end
  end
end
