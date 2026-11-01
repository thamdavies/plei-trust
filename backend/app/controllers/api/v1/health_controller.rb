module Api
  module V1
    class HealthController < ApplicationController
      def show
        @status = database_ready? ? "ok" : "unavailable"
        status_code = @status == "ok" ? :ok : :service_unavailable

        render :show, status: status_code
      end

      private

      def database_ready?
        ActiveRecord::Base.connection.select_value("SELECT 1") == 1
      rescue ActiveRecord::ActiveRecordError, PG::Error
        false
      end
    end
  end
end
