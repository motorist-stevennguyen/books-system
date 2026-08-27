module Api
  module V1
    class DashboardController < Api::V1::ApiV1Controller
      def assets
        authorize User
      end
    end
  end
end
