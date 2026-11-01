if Rails.env.development?
  Rswag::Api.configure do |config|
    config.openapi_root = Rails.root.join("openapi").to_s
  end
end
