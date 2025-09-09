# == Schema Information
#
# Table name: customers
#
#  id                       :string(27)       not null, primary key
#  address                  :string
#  customer_code            :string
#  full_name                :string
#  national_id_issued_at    :date
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
end
