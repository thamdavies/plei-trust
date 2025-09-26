# frozen_string_literal: true

module Branch::Contracts
  class Create < ApplicationContract
    property :name
    property :phone
    property :province_id, default: ""
    property :ward_id, default: ""
    property :representative
    property :address
    property :invest_amount, populator: ->(options) {
      self.invest_amount = self.input_params["invest_amount"].remove_dots if self.input_params["invest_amount"].present?
    }
    property :status, default: "active"

    validation contract: DryContract do
      option :form

      params do
        required(:name).value(:filled?, max_size?: 255)
        required(:phone).value(:filled?, max_size?: 50)
        required(:province_id).value(:filled?, max_size?: 255)
        required(:ward_id).value(:filled?, max_size?: 255)
        required(:status).value(included_in?: Branch.statuses.keys)
        required(:invest_amount).filled(:string)

        optional(:representative).value(max_size?: 255)
        optional(:address).value(max_size?: 255)
      end

      rule(:ward_id) do
        if value.present? && form.province_id.present?
          unless Ward.where(code: value, province_code: form.province_id).exists?
            key.failure("không hợp lệ")
          end
        end
      end

      rule(:phone) do
        if value.present? && !Phonelib.valid?(value.gsub(/\s+/, ""))
          key.failure(:invalid_phone_number)
        end
      end

      rule(:invest_amount) do
        if value && (value.to_d / 1000) > 100_000_000
          key.failure("không được vượt quá 100 tỷ đồng")
        end

        if value.present? && (value.to_d / 1000) < 1
          key.failure("phải lớn hơn hoặc bằng 1.000")
        end
      end
    end
  end
end
