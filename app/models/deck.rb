class Deck < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :cards
  
  validates :name, presence: true, length: { maximum: 20 },
                   uniqueness: { case_sensitive: true }
  validates :user, presence: true
  
  def current?
    self.id == self.user.current_deck.id
  end
end
