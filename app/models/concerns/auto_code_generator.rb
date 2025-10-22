# app/models/concerns/auto_code_generator.rb
module AutoCodeGenerator
  extend ActiveSupport::Concern

  included do
    before_create :set_auto_code
  end

  class_methods do
    def auto_code_config(prefix:, field: :code, length: 6, redis_key: nil)
      @auto_code_prefix = prefix
      @auto_code_field = field
      @auto_code_length = length
      @auto_code_redis_key = redis_key || "#{name.underscore}_code_counter"
    end

    def auto_code_prefix
      @auto_code_prefix || raise("Must configure auto_code_prefix using auto_code_config")
    end

    def auto_code_field
      @auto_code_field || :code
    end

    def auto_code_length
      @auto_code_length || 6
    end

    def auto_code_redis_key
      @auto_code_redis_key || "#{name.underscore}_code_counter"
    end

    def reset_auto_code_counter!
      redis = PleiTrust.redis
      last_code = self.maximum(auto_code_field)

      if last_code.present?
        last_number = extract_number_from_auto_code(last_code)
        redis.set(auto_code_redis_key, last_number)
      else
        redis.del(auto_code_redis_key)
      end
    end

    def extract_number_from_auto_code(code)
      return 0 if code.blank?

      # Remove prefix and convert to integer
      code[auto_code_prefix.length..].to_i
    end
  end

  private

  def set_auto_code
    field_name = self.class.auto_code_field
    self.send("#{field_name}=", generate_auto_code)
  end

  def generate_auto_code
    redis_key = self.class.auto_code_redis_key

    # Sử dụng Redis Lua script để đảm bảo atomicity
    counter = execute_atomic_increment(redis_key)

    if counter.nil?
      # Fallback nếu Redis fail
      counter = generate_from_database_with_lock
    end

    format_auto_code(counter)
  end

  def execute_atomic_increment(redis_key)
    redis = PleiTrust.redis

    # Lua script đảm bảo atomic operation
    lua_script = <<~LUA
      local key = KEYS[1]
      local current = redis.call('GET', key)

      if current then
        return redis.call('INCR', key)
      else
        -- Key không tồn tại, cần sync với DB
        return nil
      end
    LUA

    result = redis.eval(lua_script, keys: [ redis_key ])

    # Nếu nil, cần sync với DB
    if result.nil?
      sync_with_database(redis_key)
    else
      result
    end
  rescue StandardError => e
    Rails.logger.error "Redis error in auto code generation: #{e.message}"
    nil
  end

  def sync_with_database(redis_key)
    # Sử dụng Redis SET NX để tránh multiple sync
    sync_lock_key = "#{redis_key}_sync"
    redis = PleiTrust.redis

    # Thử set lock với expiry 30 giây
    if redis.set(sync_lock_key, "1", nx: true, ex: 30)
      begin
        field_name = self.class.auto_code_field
        last_code = self.class.maximum(field_name)

        next_number = if last_code.present?
                       self.class.extract_number_from_auto_code(last_code) + 1
        else
                       1
        end

        redis.set(redis_key, next_number)
        redis.incr(redis_key)
      ensure
        redis.del(sync_lock_key)
      end
    else
      # Không lấy được lock, đợi và retry
      sleep(0.01)
      current = redis.get(redis_key)
      current ? redis.incr(redis_key) : generate_from_database_with_lock
    end
  end

  def generate_from_database_with_lock
    self.class.transaction do
      field_name = self.class.auto_code_field
      last_record = self.class.lock.order(:created_at).last

      if last_record.nil?
        1
      else
        last_code = last_record.send(field_name)
        self.class.extract_number_from_auto_code(last_code) + 1
      end
    end
  end

  def format_auto_code(number)
    prefix = self.class.auto_code_prefix
    length = self.class.auto_code_length
    "#{prefix}#{number.to_s.rjust(length, '0')}"
  end
end
