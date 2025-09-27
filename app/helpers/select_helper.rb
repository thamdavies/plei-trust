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
end
