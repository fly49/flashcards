class Card < ActiveRecord::Base
  validates :original_text, presence: true, length: { maximum: 20 }
  validates :translated_text, presence: true, length: { maximum: 20 }
end
