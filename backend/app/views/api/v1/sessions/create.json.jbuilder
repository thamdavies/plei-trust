json.access_token @access_token
json.token_type "Bearer"
json.expires_at @api_token.expires_at
json.user do
  json.id @user.id
  json.username @user.username
  json.account do
    json.id @account.id
    json.name @account.name
  end
  json.role @membership.account_role.system_key
  json.permissions @membership.effective_permissions.map(&:key)
end
