class DashboardController < ApplicationController
  layout false

  before_action :require_login

  def index
  end
end
