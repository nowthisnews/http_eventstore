module HttpEventstore
  class Connection
    attr_accessor :scheme, :endpoint, :port, :page_size, :http_adapter

    def initialize
      setup_defaults
      yield(self) if block_given?
    end

    def update_stream_metadata(*args)
      client.update_stream_metadata(*args)
    end

    def append_to_stream(stream_name, event_data, expected_version = nil)
      Actions::AppendEventToStream.new(client).call(stream_name, event_data, expected_version)
    end

    def append_events_to_stream(stream_name, events_data, expected_version = nil)
      Actions::AppendEventsToStream.new(client).call(stream_name, events_data, expected_version)
    end

    def delete_stream(stream_name, hard_delete = false)
      Actions::DeleteStream.new(client).call(stream_name, hard_delete)
    end

    def read_events_forward(stream_name, start, count, pool = 0)
      Actions::ReadStreamEventsForward.new(client).call(stream_name, start, count, pool)
    end

    def read_events_backward(stream_name, start, count)
      Actions::ReadStreamEventsBackward.new(client).call(stream_name, start, count)
    end

    def read_all_events_forward(stream_name)
      Actions::ReadAllStreamEventsForward.new(client, page_size).call(stream_name)
    end

    def read_all_events_backward(stream_name)
      Actions::ReadAllStreamEventsBackward.new(client, page_size).call(stream_name)
    end

    def read_stream_new_events_forward(stream_name)
      @action ||= Actions::ReadStreamNewEventsForward.new(client, page_size)
      @action.call(stream_name)
    end

    def request(*args)
      client.make_request(*args)
    end

    private

    def client
      @client ||= Api::Client.new(scheme, endpoint, port, page_size, http_adapter)
    end

    def setup_defaults
      @scheme  = 'http'
      @endpoint  = 'localhost'
      @port      = 2113
      @page_size = 20
    end
  end
end
