# frozen_string_literal: true

class User < ApplicationRecord
  authenticates_with_sorcery!
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  has_many :cards
  has_many :decks
  belongs_to :current_deck, class_name: 'Deck', foreign_key: 'current_deck_id'
  before_save :downcase_email
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :current_deck, presence: true, on: :update

  scope :users_expired_cards, -> { joins(:cards).where('review_date < ?', Date.today) }

  def downcase_email
    email&.downcase!
  end

  def add_basic_deck
    basic_deck = Deck.create(name: 'Basic', user_id: id)
    update!(current_deck: basic_deck)
    decks << basic_deck
  end

  def card_for_check
    current_deck.cards.ready.random
  end

  def self.notify_cards
    User.users_expired_cards.uniq.each do |user|
      NotifyCardsJob.perform_later(user)
    end
  end

  def send_welcome_email
    SendWelcomeJob.set(wait: 20.seconds).perform_later(self)
  end
end
