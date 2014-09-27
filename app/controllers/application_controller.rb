class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def random_awesome_name
    ["Bielzebub",
    "Abrodolf Linkler",
    "McBain (butthorn)",
    "Dr. Butternut",
    "Bob Law Blah",
    "Gaylord Focker",
    "Michael Bolton",
    "Bill Lumberg",
    "Skeeter"].sample
  end
end
