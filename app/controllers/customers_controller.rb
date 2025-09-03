class CustomersController < ApplicationController
  layout false

  def index
    @customers = Customer.all

    render(Views::Customers::Index)
  end
end
