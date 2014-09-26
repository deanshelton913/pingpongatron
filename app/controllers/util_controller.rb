class UtilController < ApplicationController
  def nuke_games
    Game.delete_all
    redirect_to root_path, flash: {error: "all games were deleted"}
  end

  def nuke_sessions
    reset_session
    redirect_to root_path, flash: {error: "all sessions were deleted"}
  end

end