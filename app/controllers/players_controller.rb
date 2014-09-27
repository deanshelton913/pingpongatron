class PlayersController < ApplicationController

  def new
    @player = Player.new
  end

  def create
    player = Player.new(player_params) 
    player.save
    session[:id] = player.id
    redirect_to join_games_path
  end

  def player_params
    params.require(:player).permit(:name, :avatar)
  end

  def find
    @players = Player.where("name LIKE :prefix", prefix: "#{player_params}%")
  end
  
end
