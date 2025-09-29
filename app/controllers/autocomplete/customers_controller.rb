class Autocomplete::CustomersController < ApplicationController
  layout false

  before_action :build_ransack_query, only: [ :index ]

  def index
    run(Customer::Operations::Index, current_user:, current_branch:) do |result|
      @pagy, @customers = pagy(result[:model])
    end

    if @customers.any?
      render partial: "option", collection: @customers, as: :customer
    else
      render plain: "<li class='list-group-item text-gray-500'>Không tìm thấy kết quả phù hợp</li>".html_safe
    end
  end

  private

  def build_ransack_query
    params[:q] ||= {}
    params[:q][:full_name_cont] = params[:name] if params[:name].present?
  end
end
