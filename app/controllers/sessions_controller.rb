class SessionsController < ApplicationController
  def new
    @name = random_awesome_name
  end
  
  def create
    if params[:player][:user_id].present?
      user_id = params[:player][:user_id]
      if Player.find(user_id)
        session[:id] = user_id
        redirect_to players_path, {flash: {warning: "Welcome back!"}}
      else
        redirect_to sessions_new_path, flash: { error: "that user could not be located" }
      end
    end
  end

  def destroy
    player = Player.find(session[:id])
    if player
      if player.unresolved_game
        return redirect_to leave_games_path, flash:{warning: "You are currently in a game."}
      end
    end
    session[:id] = nil
    redirect_to root_path, flash: { warning: "You are logged out! "}
  end

  def session_params
    params.require(:player).permit(:user_id)
  end
end 