class PlayersController < ApplicationController

  def new
    @player = Player.new
  end

  def create
    player = Player.new(player_params) 
    player.save
    session[:id] = player.id
    redirect_to new_game_path
  end

  def player_params
    params.require(:player).permit(:name, :avatar)
  end
end
