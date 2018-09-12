class RecordParser
  #
  # Collect Record items into this RecordSet class.  Initially we insert them
  # unsorted at the end of an "unsorted" Array, but when they are called for
  # we sort them and move them to the "sorted" Array.  More items could be
  # added afterward, which go back into the "unsorted" Array until called for
  # again.
  #
  class RecordSet
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
