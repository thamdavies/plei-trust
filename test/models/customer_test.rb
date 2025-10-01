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
require "test_helper"

class CustomerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
