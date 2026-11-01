module UserSeeds
  def self.call
    account = Account.find_by!(slug: "pawnify")
    owner = Role.find_by!(account: account, system_key: "owner")
    password = ENV.fetch("ADMIN_PASSWORD", "12345678")

    if Rails.env.production? && (password.blank? || password == "12345678")
      raise "Set a unique ADMIN_PASSWORD before seeding a production administrator"
    end

    admin = User.find_or_initialize_by(username: "admin")
    if admin.new_record?
      admin.password = password
      admin.status = :active
      admin.save!
    end

    membership = Membership.find_or_initialize_by(account: account, user: admin)
    membership.status = :active
    membership.account_role = owner
    membership.save!
  end
end
