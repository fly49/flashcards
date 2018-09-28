class CreateCardsDecksJoin < ActiveRecord::Migration[5.2]
  def up
    create_table :cards_decks, id: false do |t|
      t.integer "card_id"
      t.integer "deck_id"
    end
    add_index("cards_decks", ["card_id", "deck_id"])
  end
  
  def down
    drop_table :cards_decks
  end
end
