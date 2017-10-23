module HttpEventstore
  module Api
    class Connection
      APP_JSON = 'application/json'.freeze

      def initialize(endpoint, http_adapter = nil)
        @http_adapter = http_adapter
        @endpoint = endpoint
      end

      def call
        Faraday.new(
            url: endpoint.url,
            headers: {
                accept: APP_JSON,
                content_type: APP_JSON
            }
        ) do |builder|
          builder.response :json, content_type: APP_JSON
          builder.response :mashify
          builder.use ErrorsHandler
          builder.adapter(http_adapter || Faraday.default_adapter)
        end
      end

      private
      attr_reader :endpoint, :http_adapter
    end
  end
end
