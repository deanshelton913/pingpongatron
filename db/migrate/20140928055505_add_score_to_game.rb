class AddScoreToGame < ActiveRecord::Migration
  def self.up
    add_column :games, :player_one_score, :integer, default: 0
    add_column :games, :player_two_score, :integer, default: 0
  end

  def self.down
    remove_column :games, :player_one_score
    remove_column :games, :player_two_score
  end
end