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
    # if translation is correct
    if original_text == translation
      evaluate_successfull_attempt
      update_card_date
    else
      # Increase failed_attempts counter
      self.failed_attempts += 1
      # Check are there 3 failures
      if failures_strike?
        update_card_date
      end
      false
    end
  end

  def texts_not_equal
    if original_text.downcase.strip == translated_text.downcase.strip
      errors.add(:translated_text, I18n.t('card.errors.translation_error'))
    end
  end
  
  private
  
  def evaluate_successfull_attempt
    # Increase successfull attempts counter
    self.successfull_attempts += 1
    # Reset failures counter
    self.failed_attempts = 0
    # successfull_attempts remains at maximum value if its exceed it
    # to correspond maximal time interval 
    self.successfull_attempts = 5 if self.successfull_attempts > 5
  end
  
  def failures_strike?
    # if counter reaches value of 3
    false if self.failed_attempts <= 3
    # failed_attempts remains at maximum value if its exceed it
    self.failed_attempts = 3
    # change time interval to the corresponding 1 succesful attempt
    self.successfull_attempts = 1
    true
  end
  
  # Update card date according to the counters
  # Each value of successfull_attempts counter correspond to specific time interval
  def update_card_date
    update!(review_date: Date.today + TIME_INTERVALS[self.successfull_attempts])
  end
end
