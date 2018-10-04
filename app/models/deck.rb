# frozen_string_literal: true

class Deck < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :cards

  validates :name, presence: true, length: { maximum: 20 },
                   uniqueness: { case_sensitive: true, scope: :user_id }
  validates :user, presence: true

  def current?
    id == user.current_deck.id
  end
end
