class RecordParser
  #
  # Collect Record items into this RecordSet class.  Initially we insert them
  # unsorted at the end of an "unsorted" Array, but when they are called for
  # we sort them and move them to the "sorted" Array.  More items could be
  # added afterward, which go back into the "unsorted" Array until called for
  # again.
  #
  class RecordSet
    SORT_ORDERS = {
      # Sort option 1: gender (female then male), last name ascending
      "option1" => ->(record) { [record.gender == :female ? 0 : record.gender == :male ? 1 : 2, record.last_name.downcase] },
      # Sort option 2: birth date ascending
      "option2" => ->(record) { record.birth_date },
      # Sort option 3: last name descending
      "option3" => ->(record) { record.last_name.downcase.each_char.map { |ch| -ch.ord } },
    }

    def initialize(sort_by:)
      @sort_by = sort_by
      @sorted_records = []
      @unsorted_records = []
    end

    def add_record(record)
      @unsorted_records << record.dup.freeze
    end

    def list_records
      sort_records!
      @sorted_records.dup
    end

    private

    def sort_records!
      return if @unsorted_records.empty?
      @sorted_records = (@sorted_records + @unsorted_records).sort_by(&@sort_by)
      @unsorted_records = []
    end
  end
end
