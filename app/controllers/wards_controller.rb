class WardsController < ApplicationController
  def index
    @wards = Ward.select(:code, :name).where(province_code: params[:province_code])
  end
end
