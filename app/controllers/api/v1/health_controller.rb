module Api
  module V1
    class HealthController < Api::V1::ApiV1Controller
      before_action :authenticated_request
      def status
        render json: { status: "ok" }, status: :ok
      end
    end 
  end
end