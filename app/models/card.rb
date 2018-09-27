class Card < ApplicationRecord
  belongs_to :user
  
  validates :original_text, presence: true, length: { maximum: 20 }
  validates :translated_text, presence: true, length: { maximum: 50 }
  validate :texts_not_equal
  
  scope :ready, lambda { where("review_date <= ?", Date.today ) }

  before_create lambda { self.review_date = Date.today + 3 }
  
  attr_accessor :image, :remove_image
  mount_uploader :image, CardImageUploader
  
  def self.random
    self.order(Arel.sql("RANDOM()")).first
  end
  
  def check_translation(translation)
    update_card_date if self.original_text == translation
  end
  
  def texts_not_equal
    if original_text.downcase.strip == translated_text.downcase.strip
      errors.add(:translated_text, I18n.t('card.errors.translation_error'))
    end
  end
  
  def update_card_date
    self.update_attribute(:review_date, Date.today + 3)
  end
end
