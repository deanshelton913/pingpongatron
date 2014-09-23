class SessionsController < ApplicationController
  def new
  end
  
  def create
    if params[:player][:user_id].present?
      user_id = params[:player][:user_id]
      if Player.find(user_id)
        session[:id] = user_id
        redirect_to games_new_path
      else
        redirect_to sessions_new_path, flash: { error: "that user could not be located" }
      end
    end
  end

  def session_params
    params.require(:session).permit(:user_id)
  end
end 