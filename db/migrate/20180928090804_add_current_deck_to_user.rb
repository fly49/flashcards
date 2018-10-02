class AddCurrentDeckToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :current_deck_id, :integer
  end
end
