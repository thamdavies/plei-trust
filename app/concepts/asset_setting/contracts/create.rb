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

    # Nested properties cho asset_setting_attributes
    collection :asset_setting_attributes, populate_if_empty: AssetSettingAttribute do
      property :id
      property :attribute_name
      property :_destroy

      validates :attribute_name, presence: true

      # Custom validation để skip khi _destroy = true
      validate :attribute_name_present_unless_destroyed

      private

      def attribute_name_present_unless_destroyed
        return if _destroy == "1" || _destroy == true

        errors.add(:attribute_name, "can't be blank") if attribute_name.blank?
      end
    end

    validation contract: DryContract do
      params do
        required(:asset_name).filled(:string)
        required(:asset_code).filled(:string)
        optional(:status).maybe(:string, included_in?: %w[active inactive])
      end
    end
  end
end
