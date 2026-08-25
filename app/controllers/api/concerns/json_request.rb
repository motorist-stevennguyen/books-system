module Api
  module Concerns
    module JsonRequest
      extend ActiveSupport::Concern

      included do
        before_action :ensure_json_request
      end

      private
      def is_request_with_body?
        request.post? || request.put? || request.patch?
      end

      def ensure_json_request
        return if !is_request_with_body? || request.content_type&.include?("json") && request.format == :json
        render nothing: true, status: 406
      end
    end
  end
end
