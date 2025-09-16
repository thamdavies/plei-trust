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
    property :default_loan_amount
    property :default_loan_duration_days
    property :default_interest_rate
    property :liquidation_after_days
    property :interest_period
    property :interest_calculation_method
    property :collect_interest_in_advance

    # Others
    property :status, default: "active"
    property :asset_setting_categories, default: []

    validation contract: DryContract do
      params do
        required(:asset_name).filled(:string)
        required(:asset_code).filled(:string)
        optional(:status).maybe(:string, included_in?: %w[active inactive])
      end
    end
  end
end
