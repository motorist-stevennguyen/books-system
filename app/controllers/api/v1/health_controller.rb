module Api
  module V1
    class HealthController < Api::V1::ApiV1Controller
      def status
        render json: { status: "ok" }, status: :ok
      end
    end
  end
end
