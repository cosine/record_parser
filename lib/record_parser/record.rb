class RecordParser
  class Record
    attr_reader :last_name, :first_name, :gender, :favorite_color, :birth_date

    def initialize(last_name:, first_name:, gender:, favorite_color:, birth_date:)
      @last_name = last_name
      @first_name = first_name
      @gender = parse_gender(gender)
      @favorite_color = favorite_color
      @birth_date = birth_date
    end

    SORT_ORDERS = {
      # Sort option 1: gender (female then male), last name ascending
      option1: ->(record) { [record.gender == :female ? 0 : record.gender == :male ? 1 : 2, record.last_name.downcase] },
      # Sort option 2: birth date ascending
      option2: ->(record) { record.birth_date },
      # Sort option 3: last name descending
      option3: ->(record) { record.last_name.downcase.each_char.map { |ch| -ch.ord } },
    }

    private

    def parse_gender(gender)
      case gender[0].downcase
        when "f" then :female
        when "m" then :male
        else :other
      end
    end
  end
end
