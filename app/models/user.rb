# frozen_string_literal: true

class User < ApplicationRecord
  VALID_EMAIL_REGEX =
    /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  validates :name, presence: true, length: { maximum: 255 }
  validates(
    :email,
    presence: true,
    uniqueness: true,
    length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX }
  )
  validates :password, presence: true, length: { minimum: 6 }
  before_validation { email.downcase! }

  has_secure_password

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
