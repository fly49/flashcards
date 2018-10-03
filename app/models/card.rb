# frozen_string_literal: true

class Card < ApplicationRecord
  TIME_INTERVALS = [0, 1, 3, 7, 14, 28].freeze

  belongs_to :user
  has_and_belongs_to_many :decks

  validates :original_text, presence: true, length: { maximum: 20 }
  validates :translated_text, presence: true, length: { maximum: 50 }
  validate :texts_not_equal
  validate :one_deck_at_least?

  scope :ready, -> { where('review_date <= ?', Date.today) }

  before_create -> { self.review_date = Date.today }

  mount_uploader :image, CardImageUploader

  def one_deck_at_least?
    errors.add(:decks, 'need one deck at least') if decks.empty?
  end

  def self.random
    order(Arel.sql('RANDOM()')).first
  end

  def check_translation(translation)
    if original_text == translation
      self.successfull_attempts += 1
      self.failed_attempts = 0
      self.successfull_attempts = 5 if self.successfull_attempts > 5
      update_card_date
    else
      self.failed_attempts += 1
      if self.failed_attempts >= 3
        self.failed_attempts = 3
        self.successfull_attempts = 1
        update_card_date
      end
    end
  end

  def texts_not_equal
    if original_text.downcase.strip == translated_text.downcase.strip
      errors.add(:translated_text, I18n.t('card.errors.translation_error'))
    end
  end

  def update_card_date
    p self.successfull_attempts
    p self.failed_attempts
    update!(review_date: Date.today + TIME_INTERVALS[self.successfull_attempts])
  end
end
