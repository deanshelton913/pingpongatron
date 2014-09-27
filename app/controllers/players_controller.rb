class PlayersController < ApplicationController

  def new
    @player = Player.new
  end

  def create
    player_params['name'].downcase!
    player = Player.new(player_params) 
    if player.save
      session[:id] = player.id
      return redirect_to join_games_path
    end
    redirect_to root_path, flash:{error: player.errors.full_messages.first}
  end

  def player_params
    params.require(:player).permit(:name, :avatar)
  end
  
end
