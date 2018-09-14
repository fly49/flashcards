class Card < ActiveRecord::Base
  validates :original_text, presence: true, length: { maximum: 20 }
  validates :translated_text, presence: true, length: { maximum: 50 }
  validate :texts_not_equal
  
  before_create :set_review_date
  
  def texts_not_equal
    if original_text.downcase.strip == translated_text.downcase.strip
      errors.add(:translated_text, "can't be the same as original text")
    end
  end
  
  def set_review_date
    self.review_date = Date.today + 3
  end
end
