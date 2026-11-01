if Rails.env.development?
  Rswag::Ui.configure do |config|
    config.openapi_endpoint "/api-docs/openapi.yaml", "Pawnify API v1"
    config.config_object["docExpansion"] = "list"
  end
end
