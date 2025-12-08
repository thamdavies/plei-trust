class ContractsController < ApplicationController
  private

  def set_contract
    @contract = Contract.find(contract_id).decorate
  end

  def contract_id
    raise NotImplementedError
  end

  def handle_cannot_operate_on_ended_contract
    flash.now[:error] = "Không thể thao tác trên hợp đồng đã kết thúc."
  end

  def permit_params
    form_params = params.require(:form).permit(
      :customer_id,
      :loan_amount,
      :contract_date,
      :interest_calculation_method,
      :interest_rate,
      :interest_period,
      :contract_term,
      :note,
      :collect_interest_in_advance,
      :asset_setting_id,
      :asset_name,
      customer: [
        :id,
        :full_name,
        :national_id,
        :phone,
        :national_id_issued_date,
        :national_id_issued_place,
        :address
      ],
      asset_setting_values: [
        :asset_setting_attribute_id,
        :value
      ]
    )

    # Merge created_by_id vào customer nếu có customer data
    if form_params[:customer].present?
      form_params[:customer].merge!(
        created_by_id: current_user.id,
        branch_id: current_branch.id
      )

      form_params[:customer].merge!(id: form_params[:customer_id]) if form_params[:customer_id].present?
    end

    # Merge contract level data
    form_params.merge!(
      created_by_id: current_user.id,
      branch_id: current_branch.id,
      cashier_id: current_user.id,
      contract_type_code: contract_type_code,
    )

    form_params
  end

  def contract_type_code; end
end
