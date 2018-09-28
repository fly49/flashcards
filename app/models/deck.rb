class Deck < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :cards
  
  validates :user, presence: true
end
