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

  def vote_action_path(resource, action)
    url_for(controller: resource.model_name.route_key, action: action, id: resource.id, only_path: true)
  end

  def vote_control(resource, action, result, icon)
    action_icon = octicon icon, width: 24

    case action
    when 'vote_up'
      case result
      when 1
        link_to action_icon, vote_action_path(resource, 'vote_delete'), title: 'Cancel vote', method: :delete,
                remote: true, class: 'vote-action voted-up'
      when 0
        link_to action_icon, vote_action_path(resource, 'vote_up'), title:'Vote up', method: :post,
                remote: true, class: 'vote-action'
      when -1
        content_tag :div, action_icon, class: 'vote-action'
      end
    when 'vote_down'
      case result
      when 1
        content_tag :div, action_icon, class: 'vote-action'
      when 0
        link_to action_icon, vote_action_path(resource, 'vote_down'), title:'Vote down', method: :post,
                remote: true, class: 'vote-action'
      when -1
        link_to action_icon, vote_action_path(resource, 'vote_delete'), title: 'Cancel vote', method: :delete,
                remote: true, class: 'vote-action voted-down'
      end
    else
      raise RuntimeError, "Unexpected action type: #{action}"
    end
  end
end
