class ContractsController < ApplicationController
  private

  def set_contract
    @contract = Contract.find(contract_id).decorate
  end

  def contract_id
    raise NotImplementedError
  end

  def handle_cannot_operate_on_ended_contract
    flash.now[:alert] = "Không thể thao tác trên hợp đồng đã kết thúc."
  end
end
