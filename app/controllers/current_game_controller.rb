class CurrentGameController < WebsocketRails::BaseController
  def initialize_session
    controller_store[:message_count] = 0
  end

  def hello
    controller_store[:current_game_state] = Game.with_opening || Game.in_progress
    # broadcast_game_state_change("Hello!")
  end

  def goodbye
    # delete game/remove player
    broadcast_game_state_change("Bye!")
  end

  # senders
  def broadcast_game_state_change(info=nil)
    broadcast_message :game_state_change, { info: info, game_state: controller_store[:current_game_state].formatted}
    rescue StandardError => e
      trigger_failure e.message
  end
  
  # receivers
  def add_player
    info = "Still waiting for opponent."
    if controller_store[:current_game_state].nil? # you are player 1
      game = Game.new(player_one_id: message['player_id'])
      info = "You are the first one here."
    else # you are player 2
      game = controller_store[:current_game_state]
      unless game.player_one_id.to_i == message['player_id']
        game.player_two_id = message['player_id'] 
        info = "Player two has entered the game #{message}"
      end
    end
    game.save
    controller_store[:current_game_state] = game
    broadcast_game_state_change(info)
  end

  # def remove_player
  # end

  def increment_score
    game = controller_store[:current_game_state]
    game.player_one_score += 1 if game.player_one_id == message['player_id']
    game.player_two_score += 1 if game.player_two_id == message['player_id']
    info = Player.find(message['player_id']).name + ' scored'
    game.save
    broadcast_game_state_change(info)
  end

  def decrement_score
    game = controller_store[:current_game_state]
    game.player_one_score -= 1 if game.player_one_id == message['player_id']
    game.player_two_score -= 1 if game.player_two_id == message['player_id']
    game.save
    controller_store[:current_game_state] = game
    broadcast_game_state_change("Player score decremented")
  end

  # def change_service
  # end
end