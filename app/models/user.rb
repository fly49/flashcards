# frozen_string_literal: true

class User < ApplicationRecord
  authenticates_with_sorcery!
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  has_many :cards
  before_save :downcase_email
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, confirmation: true
  
  def downcase_email
    email.downcase! if email
  end
end
