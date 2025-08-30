class ApplicationRecord < ActiveRecord::Base
  include ActiveRecord::KSUID[:id]

  primary_abstract_class
end
