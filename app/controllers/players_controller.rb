class PlayersController < ApplicationController

  def index
    @players = Player.order('rating desc')
  end
  
  def new
    return redirect_to players_path if session[:id]
    @player = Player.new
  end

  def create
    player_params['name'].downcase!
    player = Player.new(player_params) 
    if player.save
      session[:id] = player.id
      return redirect_to matchmaking_games_path
    end
    redirect_to root_path, flash:{error: player.errors.full_messages.first}
  end

  def player_params
    params.require(:player).permit(:name, :avatar)
  end

  def self.must_be_anon
  end
  
end
