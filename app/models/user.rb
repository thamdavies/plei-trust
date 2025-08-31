class User < ApplicationRecord
  include Clearance::User

  validates :email, presence: true, email: true
  validates :password, presence: true, length: { minimum: 6 }, unless: :skip_password_validation?

  def self.validate_email(email)
    self.new(email: email, password: SecureRandom.uuid)
  end
end
