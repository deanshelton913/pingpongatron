require 'elo'

class Player < ActiveRecord::Base
  has_attached_file :avatar, 
    :styles => { :medium => "300x300>", :thumb => "100x100>" }, 
    :convert_options => { :all => '-auto-orient' }, 
    :default_url =>  "/assets/"+ActionController::Base.helpers.asset_path("/fallback/ping_pong.png", :digest => false)
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  attr_accessor :thumb

  def thumbnail
    avatar.url(:thumb)
  end

  def full_avatar
    avatar.url
  end

  def a_game
    arel_relation Game
  end

  def games
    Game.where(a_game[:player_one_id].eq(id).or(a_game[:player_two_id].eq(id)))
  end

  def victories
    Game.where("player_one_id = #{id} AND result >= 1 OR player_two_id = #{id} AND result = 0")
    # Game.where(a_game[:player_one_id].eq(id).and('result >= 1').or(a_game[:player_two_id].eq(id)).and('result = 0'))
  end

  def unresolved_game
    # Game.where(a_game[:player_one_id].eq(id).and(a_game[:player_one_id].id(nil)).or(a_game[:player_two_id].eq(id)).and(a_game[:player_one_id].id(nil)))
    Game.where("(player_one_id = #{id} OR player_two_id = #{id}) AND result IS NULL").first
  end

  def defeats
    Game.where("player_one_id = #{id} AND result = 0 OR player_two_id = #{id} AND result >= 1")
    # Game.where(a_game[:player_one_id].eq(id).and('result = 0').or(a_game[:player_two_id].eq(id)).and('result >= 1'))
  end

  def arel_relation(model)
    model.arel_table
  end

  # The rating you provided, or the default rating from configuration
  # def rating
  #   @rating ||= Elo.config.default_rating
  # end

	# The number of games played is needed for calculating the K-factor.
  def games_played
    @games_played ||= games.size
  end
  
  # Is the player considered a pro, because his/her rating crossed
	# the threshold configured? This is needed for calculating the K-factor.
  def pro_rating?
    self.rating >= Elo.config.pro_rating_boundry
  end
  
  # Is the player just starting? Provide the boundry for
	# the amount of games played in the configuration.
	# This is needed for calculating the K-factor.
  def starter?
    games_played < Elo.config.starter_boundry
  end

	# FIDE regulations specify that once you reach a pro status
	# (see +pro_rating?+), you are considered a pro for life.
	#
	# You might need to specify it manually, when depending on
	# external persistence of players.
	#
	#		Elo::Player.new(:pro => true)
  def pro?
    !!@pro
  end
  
  
  # Calculates the K-factor for the player.
	# Elo allows you specify custom Rules (see Elo::Configuration).
	#
	# You can set it manually, if you wish:
	#
	#		Elo::Player.new(:k_factor => 10)
	#
	#	This stops this player from using the K-factor rules.
  def k_factor
    return @k_factor if @k_factor
    Elo.config.applied_k_factors.each do |rule|
      return rule[:factor] if instance_eval(&rule[:rule])
    end
    Elo.config.default_k_factor
  end
  
  
  # Start a game with another player. At this point, no
	# result is known and nothing really happens.
  def versus(other_player, options = {})
    Game.new(options.merge(:player_one => self, :player_two => other_player)).calculate
  end

	# Start a game with another player and set the score
	# immediately.
  def wins_from(other_player, options = {})
    versus(other_player, options).win
  end

	# Start a game with another player and set the score
	# immediately.
  def plays_draw(other_player, options = {})
    versus(other_player, options).draw
  end

	# Start a game with another player and set the score
	# immediately.
  def loses_from(other_player, options = {})
    versus(other_player, options).lose
  end
  
  
  private

  # A Game tells the players informed to update their
  # scores, after it knows the result (so it can calculate the rating).
  #
  # This method is private, because it is called automatically.
  # Therefore it is not part of the public API of Elo.
  def played(game)
    games << game
    self.rating = game.ratings[self].new_rating
    @pro    = true if pro_rating?
    save
  end
  
  
end
