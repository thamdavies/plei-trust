class Ward < ApplicationRecord
  belongs_to :district
  belongs_to :province, foreign_key: :province_code, primary_key: :code
  has_many :branches
end
