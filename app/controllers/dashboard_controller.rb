class DashboardController < ApplicationController
  layout false

  before_action :require_login

  def index
    render(Views::Dashboard::Index.new())
  end
end
