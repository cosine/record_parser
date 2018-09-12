require "date"

class RecordParser
  class Record
    FIELDS = [:last_name, :first_name, :gender, :favorite_color, :birth_date]
    attr_reader *FIELDS

    def initialize(field_data)
      raise InvalidFieldData if field_data.size != FIELDS.size
      @last_name = field_data[0]
      @first_name = field_data[1]
      @gender = parse_gender(field_data[2])
      @favorite_color = field_data[3]
      @birth_date = parse_date(field_data[4])
    end

    SORT_ORDERS = {
      # Sort option 1: gender (female then male), last name ascending
      "option1" => ->(record) { [record.gender == :female ? 0 : record.gender == :male ? 1 : 2, record.last_name.downcase] },
      # Sort option 2: birth date ascending
      "option2" => ->(record) { record.birth_date },
      # Sort option 3: last name descending
      "option3" => ->(record) { record.last_name.downcase.each_char.map { |ch| -ch.ord } },
    }

    private

    def parse_gender(gender)
      case gender[0].to_s.downcase
        when "f" then :female
        when "m" then :male
        else :other
      end
    end

    def parse_date(date)
      # This is to catch case when we already are passed a Date or Date-like object.
      if date.respond_to?(:to_date)
        date.to_date

      # Otherwise we assume a String was input, and we just need to figure out format.
      elsif date =~ %r"\A\d+/\d+/\d+\z"
        Date.strptime(date, "%m/%d/%Y")

      # If the date string was not in the above format, Date.parse will do the right thing.
      else
        Date.parse(date)
      end
    end
  end
end
