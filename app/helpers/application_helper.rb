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
end
