module AttachmentsHelper
  def generate_css_selector(resource)
    case resource.class.to_s
    when 'Question'
      ".question .question-attached-files"
    when 'Answer'
      ".answer-#{resource.id} .answer-attached-files"
    else
      raise RuntimeError, "Unexpected resource type: #{resource.class.to_s}"
    end
  end
end
