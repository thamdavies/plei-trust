# Seed the stable permission catalog, account owner grants, and initial administrator.
require_relative "seeds/permissions"
require_relative "seeds/roles"
require_relative "seeds/users"

PermissionSeeds.call
RoleSeeds.call
UserSeeds.call
