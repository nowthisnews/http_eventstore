require 'http_eventstore/version'
require 'http_eventstore/api/client'
require 'http_eventstore/api/connection'
require 'http_eventstore/api/errors_handler'
require 'http_eventstore/connection'
require 'http_eventstore/event'
require 'http_eventstore/errors'
require 'http_eventstore/endpoint'
require 'http_eventstore/helpers/parse_entries'
require 'http_eventstore/actions/append_event_to_stream'
require 'http_eventstore/actions/append_events_to_stream'
require 'http_eventstore/actions/delete_stream'
require 'http_eventstore/actions/read_all_stream_events'
require 'http_eventstore/actions/read_all_stream_events_backward'
require 'http_eventstore/actions/read_all_stream_events_forward'
require 'http_eventstore/actions/read_stream_events_backward'
require 'http_eventstore/actions/read_stream_events_forward'
require 'http_eventstore/actions/read_stream_new_events_forward'

module HttpEventstore
  class << self
    attr_accessor :http_adapter
  end
end
