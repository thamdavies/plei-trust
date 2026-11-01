json.user do
  json.id @user.id
  json.username @user.username
  json.name @user.name if @user.respond_to?(:name)
end
json.account do
  json.id @account.id
  json.name @account.name
  json.slug @account.slug
end
json.membership do
  json.role @membership.account_role.system_key
end
