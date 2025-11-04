class ContractPolicy < ApplicationPolicy
  # Only allow updates if the contract is not closed
  def update?
    !record.closed?
  end
end
