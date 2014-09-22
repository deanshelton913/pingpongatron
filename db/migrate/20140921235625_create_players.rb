class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.string :picture
      t.integer :rank_id

      t.timestamps
    end
  end
end
