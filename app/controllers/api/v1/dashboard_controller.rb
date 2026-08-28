module Api
  module V1
    class DashboardController < Api::V1::ApiV1Controller
        def user_growth
          period = params[:period] || Consts::PeriodEnum::MONTH
          puts period
          stat = User.growth(User, period)
          render json: stat.to_h
        end

        def user_chart
          period = params[:period] || Consts::PeriodEnum::MONTH
          puts period
          stat = User.chart(User.active, period)
          render json: stat.to_h
          rescue ArgumentError => e
            render json: { error: e.message }, status: :bad_request
        end
      end
    end
  end
