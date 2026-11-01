module Api
  module V1
    class MeController < ApplicationController
      include Authentication

      def show
        @user = Current.user
        @account = Current.account
        @membership = Current.membership
      end
    end
  end
end
