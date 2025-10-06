# == Schema Information
#
# Table name: administrative_units
#
#  id            :integer          not null, primary key
#  code_name     :string(255)
#  code_name_en  :string(255)
#  full_name     :string(255)
#  full_name_en  :string(255)
#  short_name    :string(255)
#  short_name_en :string(255)
#
class AdministrativeUnit < ApplicationRecord
end
