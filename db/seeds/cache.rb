puts "🌱 Clearing auto code counters..."

redis = PleiTrust.redis
keys = redis.keys("*_code_counter")
redis.del(*keys) if keys.any?
puts "✅ Cleared auto code counters: #{keys.join(', ')}"
