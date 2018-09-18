class Card < ActiveRecord::Base
  validates :original_text, presence: true, length: { maximum: 20 }
  validates :translated_text, presence: true, length: { maximum: 50 }
  validate :texts_not_equal
  
  scope :ready, lambda { where("review_date <= ?", Date.today ) }

  before_create lambda { self.review_date = Date.today + 3 }
  
  def self.random
    self.order("RANDOM()").first
  end
  
  def texts_not_equal
    if original_text.downcase.strip == translated_text.downcase.strip
      errors.add(:translated_text, "can't be the same as original text")
    end
  end
  
  def update_card_date
    self.review_date = Date.today + 3
    self.save
  end
end
