class AddCheckAttemptsToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :successfull_attempts, :integer, :default => 0
    add_column :cards, :failed_attempts, :integer, default: 0
  end
end
