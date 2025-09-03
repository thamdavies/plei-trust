# == Schema Information
#
# Table name: users
#
#  id                 :string(27)       not null, primary key
#  confirmation_token :string(128)
#  email              :string           not null
#  encrypted_password :string(128)      not null
#  full_name          :string           not null
#  phone              :string
#  remember_token     :string(128)      not null
#  status             :string           default("active")
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  branch_id          :string           not null
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
  include Clearance::User

  validates :email, presence: true, email: true
  validates :password, presence: true, length: { minimum: 6 }, unless: :skip_password_validation?

  def self.validate_email(email)
    self.new(email: email, password: SecureRandom.uuid)
  end
end
