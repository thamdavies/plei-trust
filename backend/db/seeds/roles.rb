module RoleSeeds
  def self.call
    account = Account.find_or_create_by!(slug: "pawnify") do |record|
      record.name = "Pawnify"
      record.currency = "VND"
    end

    owner = Role.find_or_initialize_by(account: account, system_key: "owner")
    owner.name = "Owner"
    owner.scope = :account
    owner.save!

    Permission.where(assignable: true).find_each do |permission|
      RolePermission.find_or_create_by!(account: account, role: owner, permission: permission)
    end
  end
end
