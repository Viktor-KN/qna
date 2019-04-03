module ApplicationHelper
  STYLE_KEYS = { notice: 'success', alert: 'danger' }.freeze

  def key_to_style(key)
    "alert-#{STYLE_KEYS[key.to_sym]}"
  end

  def generate_css_selector(resource, attach_type)
    case resource.class.to_s
    when 'Question'
      ".question .question-attached-#{attach_type}"
    when 'Answer'
      ".answer-#{resource.id} .answer-attached-#{attach_type}"
    else
      raise RuntimeError, "Unexpected resource type: #{resource.class.to_s}"
    end
  end
end
