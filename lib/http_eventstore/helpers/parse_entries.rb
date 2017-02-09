require 'time'
require 'colorize'

module HttpEventstore
  module Helpers
    class ParseEntries

      def call(entries)
        entries.collect do |entry|
          create_event(entry)
        end.compact
      end

      private

      def create_event(entry, intent = 0)
        id = entry['eventNumber']
        event_id = entry['eventId']
        type = entry['eventType']
        return nil unless entry['data']
        data = JSON.parse(entry['data'])
        stream_name = entry['streamId']
        position = entry['positionEventNumber']
        created_time = entry['updated'] ? Time.parse(entry['updated']) : nil
        HttpEventstore::Event.new(type, data, event_id, id, position, stream_name, created_time)
      rescue JSON::ParserError
        # TODO: Patch because of malformed event with id 56da269d-a575-4429-93d8-63fd699cc929
        # and event type "PitchOrganizationChanged" with a payload including a strange "("
        # before a JSON key.
        # http://eventstore.service.consul:2113/web/index.html#/streams/PitchingAggregate-9bc0086b-3a3c-4684-b705-3b064af64cba/3
        puts "Failed to fix malformed event with id #{entry['eventId']}.".red if intent > 0
        return nil if intent > 0
        puts "Trying to fix malformed event with id #{entry['eventId']}.".yellow
        fixed_entry = entry.dup
        fixed_entry['data'] = fixed_entry['data'].gsub(/\"(,)?(\s)?\(/, '"\1\2')
        # avoid infinite recursion in case that the error is not the same
        create_event(fixed_entry, 1)
      end
    end
  end
end
