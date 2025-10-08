module SelectHelper
  def select_options_for_contract_types
    @select_options_for_contract_types ||= ContractType.all.select(:id, :name)
  end

  def select_options_for_interest_types(contract_type: nil)
    @select_options_for_interest_types ||= begin
      types = InterestCalculationMethod.all
      if contract_type.present?
        types = types.select { |type| type.categories.include?(contract_type) }
      end

      types
    end
  end

  def select_options_for_contract_statuses
    @select_options_for_contract_statuses ||= [
      OpenStruct.new(code: "", name: "Tất cả"),
      OpenStruct.new(code: "on_time", name: "Đúng hẹn"),
      OpenStruct.new(code: "overdue", name: "Quá hạn"),
      OpenStruct.new(code: "interest_late", name: "Chậm lãi"),
      OpenStruct.new(code: "closed", name: "Đã tất toán")
    ]
  end
end
