module CapitalContract::Contracts
  class Create < ApplicationContract
    property :asset_name
    property :code
    property :contract_date
    property :contract_term_days
    property :interest_calculation_method
    property :collect_interest_in_advance, default: false
    property :interest_rate
    property :loan_amount, populator: ->(options) {
      self.loan_amount = self.input_params["loan_amount"].remove_dots if self.input_params["loan_amount"].present?
    }
    property :notes
    property :interest_period
    property :status, default: "active"
    property :customer_id
    property :contract_type_id
    property :asset_setting_id
    property :branch_id
    property :cashier_id
    property :created_by_id

    validation contract: DryContract do
      option :form

      params do
        required(:contract_date).filled
        required(:interest_calculation_method).filled
        required(:loan_amount).filled
        optional(:interest_rate).maybe(:string)
        optional(:contract_term_days).maybe(:string)
      end

      rule(:loan_amount) do
        if value && (value.to_d / 1000) > 100_000_000
          key.failure("không được vượt quá 100 tỷ đồng")
        end

        if value.present? && (value.to_d / 1000) < 1
          key.failure("phải lớn hơn hoặc bằng 1.000 đồng")
        end
      end

      rule(:interest_calculation_method) do
        unless value == "investment_capital"
          key(:interest_rate).failure("không được để trống") if form.interest_rate.blank?
          key(:interest_period).failure("không được để trống") if form.interest_period.blank?
          key(:contract_term_days).failure("không được để trống") if form.contract_term_days.blank?
        end
      end
    end

    # Nested attributes for customer
    property :customer, prepopulator: ->(options) { self.customer = options[:customer] }, populator: ->(fragment:, form:, **) {
      model = form.model
      if fragment.present? && fragment.is_a?(Hash)
        if fragment["id"].present?
          # Tìm existing customer
          existing_customer = Customer.find_by(id: fragment["id"])
          if existing_customer
            model.customer = existing_customer
            # Assign attributes để update (không tạo mới)
            existing_customer.assign_attributes(fragment.except("id"))
          else
            # Customer không tồn tại, tạo mới
            model.build_customer(fragment.except("id"))
          end
        else
          # Không có ID, tạo customer mới
          model.build_customer(fragment)
        end
      else
        # Fragment rỗng, tạo customer mới
        model.build_customer
      end

      # Return self (nested form)
      self.customer = self.model.customer
      } do
      property :id
      property :full_name
      property :national_id
      property :phone
      property :address
      property :national_id_issued_date
      property :national_id_issued_place
      property :status, default: "active"
      property :branch_id
      property :created_by_id

      validation contract: DryContract do
        params do
          required(:full_name).filled
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
  end
end
