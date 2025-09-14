class Tenant::Operations::Switch < ApplicationOperation
  step :find_branch
  step :set_tenant

  def find_branch(ctx, branch_id:, user:, **)
    ctx[:branch] = Branch.find(branch_id)
  end

  def set_tenant(ctx, user:, **)
    ActsAsTenant.current_tenant = ctx[:branch]
    cache_key = Settings.cache.current_tenant % { user_id: user.id }
    PleiTrust.redis.setex(cache_key, 24.hours.to_i, ctx[:branch].id.to_s)
  end
end
