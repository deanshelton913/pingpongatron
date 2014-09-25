class GamesController < ApplicationController
  include ApplicationHelper
  before_filter :must_be_logged_in, only:[:new, :create]

  def index
  end

  def create
    game_with_opening = Game.with_opening
    if game_with_opening 
      player1 = Player.find(game_with_opening.player_one_id)
      player2 = Player.find(session[:id])
      player1.versus(player2)
      redirect_to game_path(game_with_opening.id)
    end
    if Game.in_progress then redirect_to watching_game_path, flash: { warning: "There is currently a game in progress" } end
    redirect_to matchmaking_games_path, flash: { warning: "Waiting for opponent" }
  end

  def new
  end

  def matchmaking
    Game.new(player_one_id: session[:id]).save
  end

  def must_be_logged_in
    redirect_to signup_path if !logged_in?
  end

end
