# == Schema Information
#
# Table name: branch_contract_types
#
#  id               :uuid             not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  branch_id        :uuid             not null
#  contract_type_id :uuid             not null
#
# Indexes
#
#  index_branch_contract_types_on_branch_id         (branch_id)
#  index_branch_contract_types_on_contract_type_id  (contract_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (branch_id => branches.id)
#  fk_rails_...  (contract_type_id => contract_types.id)
#
require "test_helper"

class BranchContractTypeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
