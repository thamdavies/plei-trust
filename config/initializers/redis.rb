# frozen_string_literal: true

module PleiTrust
  class << self
    def redis
      @redis ||= ConnectionPool::Wrapper.new do
        redis_config = Rails.application.credentials[:redis] || {}
        Redis.new(
          host: redis_config[:host] || "localhost",
          port: redis_config[:port] || 6379,
          password: redis_config[:password],
          db: redis_config[:db] || 0
        )
      end
    end
  end
end

# Usage
# PleiTrust.redis.set "_key", "value"
# PleiTrust.redis.get "_key"
