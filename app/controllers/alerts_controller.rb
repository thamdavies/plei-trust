class AlertsController < ApplicationController
  def create
    if params[:type].blank? || params[:message].blank? || %w[error success].exclude?(params[:type])
      Rails.logger.warn("Invalid alert parameters: #{params.inspect}")
      return
    end

    flash.now[params[:type]] = params[:message] if params[:message].present?
  end
end
