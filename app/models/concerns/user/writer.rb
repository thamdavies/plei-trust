module User::Writer
  extend ActiveSupport::Concern

  def create_seed_capital_customer(branch:)
    return branch.seed_capital_customer if branch.seed_capital_customer.present?

    Customer.create!(
      full_name: "Vốn khởi tạo",
      created_by_id: self.id,
      branch_id: branch.id,
      status: :active,
      is_seed_capital: true
    )
  rescue StandardError => e
    Rails.logger.error(e)
  end
end
