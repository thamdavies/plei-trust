module PawnContract::Operations
  class PdfPrint < ApplicationOperation
    step Model(::PublicActivity::Activity, :find)
    step :set_parameters
    step :build_customer_info
    step :build_asset_info
    step :build_fee_info

    def set_parameters(ctx, model:, **)
      ctx[:parameters] = model.parameters
      contract_params = ctx[:parameters].dup
      contract_params.delete(:customer)
      contract_params.delete(:asset_setting_values)

      contract = ::Contract.new(contract_params)
      ctx[:contract] = contract

      true
    end

    def build_customer_info(ctx, params:, **)
      ctx[:customer_info] = [
        [ { index: 0, label: "Tên khách hàng", value: ctx[:parameters].dig(:customer, :full_name) } ],
        [
          { index: 0, label: "CMND/CCCD", value: ctx[:parameters].dig(:customer, :national_id) },
          { index: 1, label: "Số điện thoại", value: ctx[:parameters].dig(:customer, :phone) }
        ],
        [
          { index: 0, label: "Ngày cấp CMND/CCCD", value: ctx[:parameters].dig(:customer, :national_id_issued_date) },
          { index: 1, label: "Nơi cấp CMND/CCCD", value: ctx[:parameters].dig(:customer, :national_id_issued_place) }
        ]
      ]

      true
    end

    def build_asset_info(ctx, params:, **)
      contract = ctx[:contract]
      asset_setting = AssetSetting.find_by(id: ctx[:parameters].dig(:asset_setting_id))

      ctx[:asset_info] = [
        [ { index: 0, label: "Số tiền cầm cố", value: ctx[:parameters].dig(:loan_amount) } ],
        [
          { index: 0, label: "Số tiền bằng chữ", value: contract.loan_amount_words },
          { index: 1, label: "Ngày cầm cố", value: ctx[:parameters].dig(:contract_date) }
        ],
        [
          { index: 0, label: "Thời hạn cầm cố", value: contract.contract_term_in_days },
          { index: 1, label: "Phân loại tài sản", value: asset_setting&.asset_name || "" }
        ],
        [
          { index: 0, label: "Tên tài sản", value: ctx[:parameters].dig(:asset_name) },
          { index: 1, label: "Mã tài sản", value: asset_setting&.asset_code || "" }
        ]
      ]

      true
    end

    def build_fee_info(ctx, params:, **)
      contract = ctx[:contract]
      fm_interest_rate = "#{contract.interest_rate}#{contract.interest_calculation_method_obj&.percent_unit}"
      fm_interest_period = "#{contract.interest_period} #{contract.interest_calculation_method_obj&.unit}"

      ctx[:fee_info] = [
        [
          { index: 0, label: "Lãi suất cầm cố", value: fm_interest_rate },
          { index: 1, label: "Phí quản lý hợp đồng", value: 0 }
        ],
        [
          { index: 0, label: "Kỳ hạn đóng tiền", value: fm_interest_period },
          { index: 1, label: "Phí thẩm định", value: 0 }
        ]
      ]

      true
    end
  end
end
