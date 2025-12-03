module SelectHelper
  def select_options_for_contract_types
    @select_options_for_contract_types ||= ContractType.all.select(:code, :name)
  end

  def select_options_for_interest_types(contract_type: nil)
    @select_options_for_interest_types ||= begin
      types = InterestCalculationMethod.all
      if contract_type.present?
        types = types.select { |type| type.categories.include?(contract_type.to_s) }
      end

      types
    end
  end

  def select_options_for_transaction_types(is_income: nil)
    @select_options_for_transaction_types ||= begin
      if is_income
        TransactionType.income_types.select(:code, :name)
      else
        TransactionType.expense_types.select(:code, :name)
      end
    end
  end

  def select_options_for_contract_statuses
    @select_options_for_contract_statuses ||= [
      OpenStruct.new(code: "active_contracts", name: "Đang vay"),
      OpenStruct.new(code: "on_time_contracts", name: "Đúng hẹn"),
      OpenStruct.new(code: "overdue_contracts", name: "Quá hạn"),
      OpenStruct.new(code: "interest_late_contracts", name: "Chậm lãi"),
      OpenStruct.new(code: "closed_contracts", name: "Đã kết thúc")
    ]
  end

  def select_options_for_asset_types
    @select_options_for_asset_types ||= AssetSetting.all.map do |asset_setting|
      OpenStruct.new(id: asset_setting.id, name: asset_setting.asset_name)
    end
  end
end
