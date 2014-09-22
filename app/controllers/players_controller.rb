class PlayersController < ApplicationController

  def new
    @player = Player.new
  end

  def create
    player = Player.new(player_params) 
    player.save
  end

  def player_params
    params.require(:player).permit(:name, :avatar)
  end
end
