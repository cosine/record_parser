class RecordParser
  module Parsers
    class Delimited
      def initialize(split_regex)
        @split_regex = split_regex
      end

      # Either return a Record or +nil+ if we cannot parse the record.
      def parse(record_data)
        field_data = record_data.split(@split_regex)
        if field_data.size == Record::FIELDS.size
          Record.new(field_data)
        else
          nil
        end
      end
    end
  end
end
