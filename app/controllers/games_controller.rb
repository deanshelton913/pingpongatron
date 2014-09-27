class GamesController < ApplicationController
  include ApplicationHelper
  before_filter :must_be_logged_in, only:[:new, :create]

  def index
    #leaderboard
  end

  def join
    open_game = Game.with_opening
    if open_game
      if open_game.player_one_id.to_i == session[:id].to_i
        return redirect_to matchmaking_games_path, flash: { warning: "Still waiting for opponent" }
      end
      open_game.player_two_id = session[:id]
      open_game.save
      return redirect_to current_games_path, flash: { warning: "Player two has joined!" }
    end
    if Game.in_progress
      return redirect_to current_games_path, flash: { warning: "There is currently a full game in progress" }
    end
    redirect_to matchmaking_games_path, flash: { warning: "Waiting for opponent" }
  end

  def new
  end

  def destroy
    game = Game.find(params[:id])
    if game.destroy
      redirect_to signout_path, flash: {warning: "Your game has been deleted. Your failure has been hidden. ;)"}
    end
  end

  def current
    @game = Game.in_progress
    if @game.nil? 
      return redirect_to games_path, flash: {warning: "No game in progress currently"}
    end
    @player_one = Player.find(@game.player_one_id)
    @player_two = Player.find(@game.player_two_id)
  end

  def matchmaking
    @game = Player.find(session[:id]).unresolved_game
    if @game.nil?
      @game = Game.new(player_one_id: session[:id]).save
    end
  end

  def must_be_logged_in
    redirect_to signup_path if !logged_in?
  end

  def leave
    @game = Player.find(session[:id]).unresolved_game
  end

end
