class GamesController < ApplicationController
  include ApplicationHelper
  before_filter :must_be_logged_in, only:[:new, :create]

  def index
  end

  def join
    game_with_opening = Game.with_opening
    if game_with_opening
      game_with_opening.player_two_id = session[:id]
      game_with_opening.save
      return redirect_to current_games_path, flash: { warning: "Player two has joined!" }
    end
    if Game.in_progress
      return redirect_to current_games_path, flash: { warning: "There is currently a game in progress" }
    end
    redirect_to matchmaking_games_path, flash: { warning: "Waiting for opponent" }
  end

  def new
  end

  def current
    debugger
    @game = Game.in_progress
    unless game then redirect_to games_path end
    # @player_one = Player.find(@game.player_one_id)
    # @player_two = Player.find(@game.player_two_id)
    @player_one = {name:'banane'}
    @player_two = {name:'bana2'}
  end

  def matchmaking
    Game.new(player_one_id: session[:id]).save
  end

  def must_be_logged_in
    redirect_to signup_path if !logged_in?
  end

end
