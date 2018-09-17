class Card < ActiveRecord::Base
  validates :original_text, presence: true, length: { maximum: 20 }
  validates :translated_text, presence: true, length: { maximum: 50 }
  validate :texts_not_equal
  
  scope :outdated, lambda { where("review_date =< ?", Date.today ) }
  scope :random, lambda { offset(rand(Card.count)).first }

  before_create :set_review_date
  
  def texts_not_equal
    if original_text.downcase.strip == translated_text.downcase.strip
      errors.add(:translated_text, "can't be the same as original text")
    end
  end
  
  def set_review_date(date=(Date.today + 3))
    update_attribute(:review_date, date)
  end
end
