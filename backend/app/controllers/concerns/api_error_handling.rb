module ApiErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_record
    rescue_from ActionController::ParameterMissing, with: :render_bad_request
  end

  private

  def render_not_found
    render json: { error: { code: "not_found", message: "Resource not found" } }, status: :not_found
  end

  def render_invalid_record(exception)
    @error = { code: "validation_failed", message: exception.record.errors.full_messages.to_sentence }
    render "api/v1/shared/error", status: :unprocessable_entity
  end

  def render_bad_request(exception)
    render json: { error: { code: "bad_request", message: exception.message } }, status: :bad_request
  end
end
