class RecordParser
  module Parsers
    class TryMultiple
      def initialize(*component_parsers)
        @component_parsers = component_parsers
      end

      # Return the first non-nil response from the component parsers,
      # trying in order.
      def parse(record_data)
        @component_parsers.each do |parser|
          record = parser.parse(record_data)
          return record if record
        end

        nil
      end
    end
  end
end
