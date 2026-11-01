class LoginAttempt < ApplicationRecord
  FAILURE_LIMIT = 5
  COOLDOWN = 15.minutes

  normalizes :normalized_username, with: ->(username) { username.strip.downcase }
  validates :normalized_username, presence: true, uniqueness: true
  validates :failed_attempts, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def self.for_username(username)
    find_or_create_by!(normalized_username: username)
  end

  def locked?
    locked_until&.future? || false
  end

  def record_failure
    with_lock do
      if locked?
        self
      else
        if locked_until.present?
          self.failed_attempts = 0
          self.locked_until = nil
        end
        self.failed_attempts += 1
        self.locked_until = Time.current + COOLDOWN if failed_attempts >= FAILURE_LIMIT
        save!
      end
    end
  end

  def reset
    update!(failed_attempts: 0, locked_until: nil) if failed_attempts.positive? || locked_until.present?
  end
end
