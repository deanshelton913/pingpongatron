class GamesController < ApplicationController
  include ApplicationHelper
  before_filter :must_be_logged_in, only:[:new, :create]

  def new
  end

  def destroy
    game = Game.find(params[:id])
    if game.destroy
      redirect_to signout_path, flash: {warning: "Your game has been deleted. Your failure has been hidden. ;)"}
    end
  end

  def current
    game = Game.in_progress
    if game.nil?
      return redirect_to players_path, flash: {warning: "No game in progress currently"}
    end
    @game = game.formatted
  end

  def matchmaking
  end

  def must_be_logged_in
    redirect_to signup_path if !logged_in?
  end

  def leave
    @game = Player.find(session[:id]).unresolved_game
  end

end
