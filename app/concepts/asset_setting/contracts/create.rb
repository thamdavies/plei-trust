# frozen_string_literal: true

module AssetSetting::Contracts
  class Create < ApplicationContract
    # Basic Info
    property :id
    property :asset_name
    property :asset_code

    # Fees
    property :asset_appraisal_fee
    property :asset_rental_fee
    property :contract_initiation_fee
    property :early_termination_fee
    property :management_fee

    # Default values and terms
    property :default_loan_amount, populator: ->(options) {
      self.default_loan_amount = self.input_params["default_loan_amount"].remove_dot if self.input_params["default_loan_amount"].present?
    }
    property :default_loan_duration_days
    property :default_interest_rate
    property :liquidation_after_days
    property :interest_period
    property :interest_calculation_method
    property :collect_interest_in_advance

    # Others
    collection :asset_setting_categories, populate_if_empty: AssetSettingCategory do
      property :contract_type_id

      validation contract: DryContract do
        params do
          required(:contract_type_id).filled(:string)
        end
      end
    end

    property :status, default: "active"

    # Nested properties cho asset_setting_attributes
    collection :asset_setting_attributes, populate_if_empty: AssetSettingAttribute do
      property :id
      property :attribute_name
      property :_destroy, virtual: true

      validation contract: DryContract do
        params do
          required(:attribute_name).filled(:string)
        end
      end
    end

    validation contract: DryContract do
      option :form

      params do
        required(:asset_name).filled(:string)
        required(:asset_code).filled(:string)
        required(:interest_calculation_method).filled(:string)
        required(:default_loan_amount).filled(:string)
        required(:default_interest_rate).filled(:string)
        required(:interest_period).filled(:string)
        required(:liquidation_after_days).filled(:string)
        required(:default_loan_duration_days).filled(:string)
        optional(:status).value(:string, included_in?: %w[active inactive])
      end

      rule(:default_loan_amount) do
        if value && (value.to_d / 1000) > 100_000_000
          key.failure("không được vượt quá 100 tỷ đồng")
        end

        if value.present? && (value.to_d / 1000) < 1
          key.failure("phải lớn hơn hoặc bằng 1.000")
        end
      end

      rule(:asset_code) do
        if value.present?
          exclude_id = form.model.id
          query = AssetSetting.where(asset_code: value)
          query = query.where.not(id: exclude_id) if exclude_id

          if query.exists?
            key.failure("đã tồn tại")
          end
        end
      end
    end
  end
end
