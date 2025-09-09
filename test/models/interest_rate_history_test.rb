# == Schema Information
#
# Table name: interest_rate_histories
#
#  id              :string(27)       not null, primary key
#  description     :text
#  effective_date  :date             not null
#  interest_rate   :float            not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  processed_by_id :string           not null
#
# Indexes
#
#  index_interest_rate_histories_on_processed_by_id  (processed_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (processed_by_id => users.id)
#
require "test_helper"

class InterestRateHistoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
