require "optparse"

require "record_parser/record"
require "record_parser/record_set"
require "record_parser/formatter"
require "record_parser/parsers/delimited"
require "record_parser/parsers/try_multiple"

class RecordParser
  class << self
    def parser
      component_parsers = [
        RecordParser::Parsers::Delimited.new(/ *\| */),
        RecordParser::Parsers::Delimited.new(/ *, */),
        RecordParser::Parsers::Delimited.new(/ +/),
      ]

      RecordParser::Parsers::TryMultiple.new(*component_parsers)
    end

    def run_cmdline(argv, out:, err:)
      options, files = parse_options(argv)
      records = RecordSet.new(sort_by: RecordSet::SORT_ORDERS[options[:sort]])

      files.each do |filename|
        File.open(filename, "r") do |file_handle|
          while not file_handle.eof?
            record_text = file_handle.readline.chomp
            record = parser.parse(record_text)

            if record
              records.add_record(record)
            else
              err.puts("Error: unable to parse record in #{filename} line #{file_handle.lineno}.")
              return 1
            end
          end
        end
      end

      records.list_records.each do |record|
        out.puts record.inspect
      end
    end

    def parse_options(argv)
      options = {
        sort: "option1",
        outform: "comma_delimited",
      }

      files = argv.dup

      OptionParser.new do |opts|
        opts.banner = "Usage: record_parser [options]"

        opts.on("--sort SORT_OPTION", "Specify a pre-defined sort option (default: option1)") do |sort_option|
          options[:sort] = sort_option
        end

        opts.on("--outform FORMAT", "Specify an output format (default: comma_delimited)") do |outform|
          options[:outform] = outform
        end
      end.parse!(files)

      [options, files]
    end
  end
end
