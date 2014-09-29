module ApplicationHelper
  def javascript(*files)
    content_for(:head) { javascript_include_tag(*files) }
  end
  
  def logged_in?
    session[:id].present?
  end
  
  def nav_link(link_text, link_path, *other_paths)
    known_urls = [link_path] + other_paths
    class_name = known_urls.any? { |url| current_page?(url) } ? 'current' : ''

    content_tag(:li, :class => class_name) do
      link_to link_text, link_path
    end
  end
end
