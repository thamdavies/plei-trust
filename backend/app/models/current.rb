class Current < ActiveSupport::CurrentAttributes
  attribute :user, :account, :membership, :store, :api_token
end
