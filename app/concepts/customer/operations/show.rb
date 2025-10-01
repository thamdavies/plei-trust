# frozen_string_literal: true

module Customer::Operations
  class Show < ApplicationOperation
    step Model(Customer, :find)
  end
end
