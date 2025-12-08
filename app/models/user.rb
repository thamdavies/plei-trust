# == Schema Information
#
# Table name: users
#
#  id                 :uuid             not null, primary key
#  confirmation_token :string(128)
#  email              :string           not null
#  encrypted_password :string(128)      not null
#  full_name          :string           not null
#  phone              :string
#  remember_token     :string(128)      not null
#  status             :string           default("active")
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  branch_id          :uuid             not null
#
# Indexes
#
#  index_users_on_branch_id           (branch_id)
#  index_users_on_confirmation_token  (confirmation_token) UNIQUE
#  index_users_on_email               (email)
#  index_users_on_remember_token      (remember_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (branch_id => branches.id)
#
class User < ApplicationRecord
  attr_accessor :skip_password_validation

  include Clearance::User
  include User::Reader
  include User::Writer

  belongs_to :branch

  validates :email, presence: true, email: true
  validates :password, presence: true, length: { minimum: 6 }, unless: :skip_password_validation?

  def self.validate_email(email)
    self.new(email: email, password: SecureRandom.uuid)
  end

  def skip_password_validation?
    skip_password_validation || password_optional? ||
      (encrypted_password.present? && !encrypted_password_changed?)
  end

  class << self
    def ransackable_attributes(auth_object = nil)
      [ "full_name", "email", "phone", "status" ]
    end

    def ransackable_associations(auth_object = nil)
      []
    end
  end
end
