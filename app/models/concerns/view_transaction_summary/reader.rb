module ViewTransactionSummary::Reader
  extend ActiveSupport::Concern

  def readonly?
    true
  end

  def pawn?
    transactable_type_code == "pawn"
  end

  def installment?
    transactable_type_code == "installment"
  end

  def income?
    transactable_type_code == "income"
  end

  def expense?
    transactable_type_code == "expense"
  end

  def capital?
    transactable_type_code == "capital"
  end
end
