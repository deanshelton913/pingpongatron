class CurrentGameController < WebsocketRails::BaseController

  # NOTE:
  # This file shit... i know this.
  # Many of the things here are bad practice... and i know that too. :/
  # This is a hobby project, and my first attempt with web sockets.

  def initialize_session
    controller_store[:message_count] = 0
  end

  def hello
    broadcast_game_state_change("Hello!")
  end

  def goodbye
    # delete game/remove player
    # controller_store[:current_game_state].player
    broadcast_game_state_change("Bye!")
  end

  # senders
  def broadcast_game_state_change(info=nil)
    broadcast_message :game_state_change, { info: info, game_state: controller_store[:current_game_state].formatted }
    rescue StandardError => e
      trigger_failure e.message
  end

  # receivers
  def add_player
    controller_store[:current_game_state] = Game.with_opening || Game.in_progress
    info = "Still waiting for opponent."
    if controller_store[:current_game_state].nil? # you are player 1
      game = Game.new(player_one_id: message['player_id'])
      info = "You are the first one here."
    else # you are player 2...or 3...or 4
      game = controller_store[:current_game_state]
      if game.player_one_id.to_i != message['player_id'].to_i
        game.player_two_id = message['player_id'].to_i
        info = "Player two has entered the game"
      end
    end
    game.save
    controller_store[:current_game_state] = game
    broadcast_game_state_change(info)
  end

  def remove_player
  end

  def increment_score
    game = controller_store[:current_game_state]
    player = Player.find(message['player_id'])
    info = player.name + ' scored'

    if game.player_one_id == message['player_id']
      game.player_one_score += 1
      game.winner = Player.find(message['player_id']) if player_one_wins?
    end
    if game.player_two_id == message['player_id']
      game.player_two_score += 1
      game.winner = Player.find(message['player_id']) if player_two_wins?
    end
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

  def player_two_wins?
    game = controller_store[:current_game_state]
    game.player_two_score > 20 && game.player_one_score < (game.player_two_score - 1)
  end

  def player_one_wins?
    game = controller_store[:current_game_state]
    game.player_one_score > 20 && game.player_two_score < (game.player_one_score - 1)
  end

end




