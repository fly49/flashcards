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
  validates :password, length: { minimum: 6 }, confirmation: true
  validates :current_deck, presence: true, on: :update
  
  def downcase_email
    email.downcase! if email
  end
  
  def add_basic_deck
    basic_deck = Deck.create(name:'Basic', user_id: self.id)
    self.decks << (self.current_deck = basic_deck)
  end
end
