# == Schema Information
#
# Table name: customers
#
#  id                       :uuid             not null, primary key
#  address                  :string
#  customer_code            :string           not null
#  full_name                :string           not null
#  is_seed_capital          :boolean          default(FALSE)
#  national_id_issued_date  :date
#  national_id_issued_place :string
#  phone                    :string
#  status                   :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  branch_id                :uuid             not null
#  created_by_id            :uuid             not null
#  national_id              :string
#
# Indexes
#
#  index_customers_on_branch_id      (branch_id)
#  index_customers_on_created_by_id  (created_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (branch_id => branches.id)
#  fk_rails_...  (created_by_id => users.id)
#
class Customer < ApplicationRecord
  include AutoCodeGenerator

  acts_as_tenant(:branch)

  belongs_to :creator, class_name: User.name, foreign_key: :created_by_id, optional: true

  auto_code_config(prefix: "KH", field: :customer_code)

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
