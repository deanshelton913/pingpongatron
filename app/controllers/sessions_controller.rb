class SessionsController < ApplicationController
  def new
    @name = random_awesome_name
  end
  
  def create
    if params[:player][:user_id].present?
      user_id = params[:player][:user_id]
      if Player.find(user_id)
        session[:id] = user_id
        redirect_to new_game_path
      else
        redirect_to sessions_new_path, flash: { error: "that user could not be located" }
      end
    end
  end

  def destroy
    session[:id] = nil
    redirect_to root_path
  end

  def session_params
    params.require(:player).permit(:user_id)
  end
end 