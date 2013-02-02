require 'ostruct'

module NavigationHelper
  def add_breadcrumb(title, url = nil)
    @breadcrumbs << OpenStruct.new(:title => title, :url => url)
  end

  def set_title_and_breadcrumb(title, breadcrumb_text = nil, url = nil)
    set_title title
    breadcrumb_text ||= title
    add_breadcrumb breadcrumb_text, url
  end

  def set_title(page_title)
    content_for(:title) { page_title }
  end

  def set_description(page_description)
    content_for(:description) { page_description }
  end

  def body_class
    qualified_controller_name = controller.controller_path.gsub('/', '-')
    classes = [qualified_controller_name]
    classes << "#{qualified_controller_name}-#{controller.action_name}"
    classes << 'devise' if devise_controller?
    classes.join(" ")
  end

end
