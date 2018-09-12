class RecordParser
  class << self
    def run_cmdline(argv, out:, err:)
      # do nothing so far
    end
  end
end

require "record_parser/record"
require "record_parser/record_set"
require "record_parser/parsers/pipe_delimited"
require "record_parser/parsers/comma_delimited"
require "record_parser/parsers/space_delimited"
