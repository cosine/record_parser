class RecordParser
  class Formatter
    def initialize(separator)
      @separator = separator
    end

    def format(record)
      Record::FIELDS.map do |field_name|
        value = record.send(field_name)
        if value.respond_to?(:strftime)
          value.strftime("%-m/%-d/%Y")
        else
          value.to_s
        end
      end.join(@separator)
    end
  end
end
