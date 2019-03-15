module ApplicationHelper
  STYLE_KEYS = { notice: 'success', alert: 'danger' }.freeze

  def key_to_style(key)
    "alert-#{STYLE_KEYS[key.to_sym]}"
  end
end
