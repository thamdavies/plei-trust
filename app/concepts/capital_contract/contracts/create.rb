module CapitalContract::Contracts
  class Create < ApplicationContract
    property :asset_name
    property :code
    property :contract_date
    property :contract_term_days
    property :interest_calculation_method
    property :collect_interest_in_advance, default: false
    property :interest_rate
    property :loan_amount
    property :notes
    property :payment_frequency_days
    property :status
    property :asset_setting_id
    property :branch_id
    property :cashier_id
    property :contract_type_id
    property :created_by_id
    property :customer_id

    # Nested attributes for customer
    property :customer, class: Customer do
      property :id
      property :full_name
      property :national_id
      property :phone
      property :address
      property :national_id_issued_date
      property :national_id_issued_place
      property :status, default: "active"

      validation contract: DryContract do
        params do
          required(:full_name).filled
          required(:created_by_id).filled
          required(:branch_id).filled
          optional(:phone).value(max_size?: 50)
          optional(:national_id).value(max_size?: 50)
          optional(:national_id_issued_date)
          optional(:national_id_issued_place).value(max_size?: 255)
          optional(:address).value(max_size?: 255)
          optional(:status).value(included_in?: Customer.statuses.keys)
        end

        rule(:phone) do
          if value.present? && !Phonelib.valid?(value.gsub(/\s+/, ""))
            key.failure(:invalid_phone_number)
          end
        end
      end
    end

    property :customer_type, default: "new", virtual: true
  end
end
