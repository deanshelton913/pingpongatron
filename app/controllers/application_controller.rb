class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def random_awesome_name
    ["Richard Cox",
    "Harry",
    "Dr. Baldock",
    "Paul Hymen",
    "Gaylord Focker",
    "Michael Bolton",
    "Bill Lumberg",
    "Skeeter",
    "Morey Bund"].sample
  end
end
