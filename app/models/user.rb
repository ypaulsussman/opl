# frozen_string_literal: true

class User < ApplicationRecord
  attr_accessor :remember_me_token

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
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def authenticated?(remember_me_token)
    return false if remember_me_digest.nil?

    BCrypt::Password.new(remember_me_digest).is_password?(remember_me_token)
  end

  def forget_me
    update_attribute(:remember_me_digest, nil)
  end

  def remember_me
    self.remember_me_token = User.new_token
    update_attribute(:remember_me_digest, User.digest(remember_me_token))
  end
end
