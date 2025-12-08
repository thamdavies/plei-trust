SlackAlarm.configure do |config|
  config.webhook_url  = Rails.application.credentials.dig(:slack, :webhook_url)
  config.channel      = Rails.application.credentials.dig(:slack, :notify_channel)
  config.username     = "DNM Bot"
  config.avatar       = ":pepeyeehaw:"
  config.hostname     = %x(hostname)
  config.ruby_version = %x(ruby -v)
end
