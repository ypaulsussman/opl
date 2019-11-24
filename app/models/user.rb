# frozen_string_literal: true

class User < ApplicationRecord
  VALID_EMAIL_REGEX =
    /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  attr_accessor :remember_me_token, :activation_token, :password_reset_token

  before_validation { email.downcase! }
  before_create :create_activation_digest

  validates :name, presence: true, length: { maximum: 255 }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates(
    :email,
    presence: true,
    uniqueness: true,
    length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX }
  )

  has_secure_password

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def activate_account
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def authenticated?(attr, token)
    digest = send("#{attr}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  def create_password_reset_digest
    self.password_reset_token = User.new_token
    update_columns(
      password_reset_digest: User.digest(password_reset_token),
      password_reset_sent_at: Time.zone.now
    )
  end

  def forget_me
    update_attribute(:remember_me_digest, nil)
  end

  def password_reset_expired?
    password_reset_sent_at < 2.hours.ago
  end

  def remember_me
    self.remember_me_token = User.new_token
    update_attribute(:remember_me_digest, User.digest(remember_me_token))
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  private

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
