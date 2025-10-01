module SelectHelper
  def select_options_for_contract_types
    @select_options_for_contract_types ||= ContractType.all.select(:id, :name)
  end

  def select_options_for_interest_types(exclude: nil)
    @select_options_for_interest_types ||= begin
      types = InterestCalculationMethod.all
      if exclude.present?
        types = types.reject { |type| type.categories.include?(exclude) }
      end

      types
    end
  end

  def select_options_for_capital_contract_statuses
    @select_options_for_capital_contract_statuses ||= [
      OpenStruct.new(code: "", name: "Tất cả"),
      OpenStruct.new(code: "on_time", name: "Đúng hẹn"),
      OpenStruct.new(code: "overdue", name: "Quá hạn"),
      OpenStruct.new(code: "interest_late", name: "Chậm lãi"),
      OpenStruct.new(code: "closed", name: "Đã tất toán")
    ]
  end
end
