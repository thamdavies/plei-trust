class ApplicationService
  attr_reader :errors, :result

  def self.call(*args, **kwargs)
    new(*args, **kwargs).call
  end

  def initialize(*args, **kwargs)
    @errors = []
    @result = nil
  end

  def success?
    errors.empty?
  end

  def failure?
    !success?
  end

  protected

  def add_error(message)
    @errors << message
  end

  def set_result(value)
    @result = value
  end
end
