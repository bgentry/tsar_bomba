module ApplicationHelper
  def bootstrap_class_for_flash_name(name)
    case name.to_s
    when "error"
      "danger"
    when "warning"
      "warning"
    else
      "success"
    end
  end

  def current_page_class(path)
    current_route = Rails.application.routes.recognize_path(path)
    "active" if current_page?(path)
  end
end
