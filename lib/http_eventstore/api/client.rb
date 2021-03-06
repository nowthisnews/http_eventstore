module HttpEventstore
  module Api
    class Client
      def initialize(scheme, endpoint, port, page_size, http_adapter = nil)
        @endpoint = Endpoint.new(scheme, endpoint, port)
        @page_size = page_size
        @http_adapter = http_adapter
      end
      attr_reader :endpoint, :page_size, :http_adapter

      def append_to_stream(stream_name, event, expected_version = nil)
        headers = {"ES-EventType" => event.type, "ES-EventId" => event.event_id, "ES-ExpectedVersion" => "#{expected_version}"}.reject { |key, val| val.empty? }
        make_request(:post, "/streams/#{stream_name}", event.data, headers)
      end

      def update_stream_metadata(stream_name, event_id: SecureRandom.uuid, data: {})
        headers = { "Content-Type" => "application/json", "ES-EventId" => event_id }
        make_request(:post, "/streams/#{stream_name}/metadata", data, headers)
      end

      def append_events_to_stream(stream_name, events=[], expected_version = nil)
        headers = {
          "Content-Type" => "application/vnd.eventstore.events+json",
          "ES-ExpectedVersion" => "#{expected_version}"}.reject { |key, val| val.empty?
        }

        data = events.map do |event|
          {
            eventId:   event.event_id,
            eventType: event.type,
            data:      event.data
          }
        end

        make_request(:post, "/streams/#{stream_name}", data, headers)
      end

      def delete_stream(stream_name, hard_delete)
        headers = {"ES-HardDelete" => "#{hard_delete}"}
        make_request(:delete, "/streams/#{stream_name}", {}, headers)
      end

      def read_stream_backward(stream_name, start, count)
        make_request(:get, "/streams/#{stream_name}/#{start}/backward/#{count}")
      end

      def read_stream_forward(stream_name, start, count, long_pool = 0)
        headers = long_pool > 0 ? {"ES-LongPoll" => "#{long_pool}"} : {}
        make_request(:get, "/streams/#{stream_name}/#{start}/forward/#{count}", {}, headers)
      end

      def read_stream_page(uri)
        make_request(:get, uri)
      end

      def make_request(method, path, body = {}, headers = {})
        connection.send(method, path) do |req|
          req.headers = req.headers.merge(headers)
          req.body = prepare_body(body, req.headers)
          req.params['embed'] = 'body' if method == :get
        end.body
      end

      private

      def prepare_body(body, headers)
        return body.to_json unless headers['Content-Type']&.match /application\/javascript/
        body
      end

      def connection
        @connection ||= Api::Connection.new(endpoint, http_adapter).call
      end
    end
  end
end
