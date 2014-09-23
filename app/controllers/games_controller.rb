class GamesController < ApplicationController
  include ApplicationHelper
  before_filter :must_be_logged_in, only:[:new]

  def index
  end

  def new

  end

  def must_be_logged_in
    redirect_to signup_path if !logged_in?
  end
end
