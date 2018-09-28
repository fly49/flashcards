class AddUserToDecks < ActiveRecord::Migration[5.2]
  def change
    add_reference :decks, :user, foreign_key: true
  end
end
