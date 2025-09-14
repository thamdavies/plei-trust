# == Schema Information
#
# Table name: customers
#
#  id                       :string(27)       not null, primary key
#  address                  :string
#  customer_code            :string
#  full_name                :string
#  national_id_issued_date  :date
#  national_id_issued_place :string
#  phone                    :string
#  status                   :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  branch_id                :string
#  created_by_id            :string           not null
#  national_id              :string
#
# Indexes
#
#  index_customers_on_created_by_id  (created_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (created_by_id => users.id)
#
class Customer < ApplicationRecord
  include AutoCodeGenerator

  acts_as_tenant

  belongs_to :creator, class_name: User.name, foreign_key: :created_by_id, optional: true

  auto_code_config(prefix: "C", field: :customer_code)

  enum :status, { active: "active", inactive: "inactive" }, default: "active"

  before_validation :strip_whitespaces

  def strip_whitespaces
    self.phone = phone.gsub(/\s+/, "") if phone.present?
  end

  class << self
    def ransackable_attributes(auth_object = nil)
      [ "full_name", "national_id", "phone", "status" ]
    end

    def ransackable_associations(auth_object = nil)
      []
    end
  end
end
