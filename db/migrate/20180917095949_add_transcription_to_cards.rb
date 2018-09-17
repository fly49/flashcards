class AddTranscriptionToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :transcription, :text
  end
end
