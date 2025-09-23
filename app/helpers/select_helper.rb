module SelectHelper
  def select_options_for_contract_types
    @select_options_for_contract_types ||= ContractType.all.select(:id, :name)
  end
end
