# == Schema Information
#
# Table name: branches
#
#  id             :uuid             not null, primary key
#  address        :string
#  invest_amount  :decimal(12, 2)
#  name           :string
#  phone          :string
#  representative :string
#  status         :string           default("active")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  province_id    :integer
#  ward_id        :integer
#
require "test_helper"

class BranchTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
