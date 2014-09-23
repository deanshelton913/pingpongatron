module ApplicationHelper
  def logged_in?
    session[:id].present?
  end
end
