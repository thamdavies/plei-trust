class Views::Incomes::Filter < Views::Expenses::Filter
  # Inherits everything from Expenses::Filter

  def form_url
    incomes_path
  end

  def income?
    true
  end
end
