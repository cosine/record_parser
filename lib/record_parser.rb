require "optparse"

require "record_parser/record"
require "record_parser/record_set"
require "record_parser/formatter"
require "record_parser/json_formatter"
require "record_parser/parsers/delimited"
require "record_parser/parsers/try_multiple"

class RecordParser
  class << self
    def create_formatter(formatter_name)
      separator_hash = {
        "pipe_delimited"  => " | ",
        "comma_delimited" => ", ",
        "space_delimited" => " ",
      }

      separator = separator_hash[formatter_name]

      if separator
        RecordParser::Formatter.new(separator)
      else
        nil
      end
    end

    def parser
      @parser ||= begin
        component_parsers = [
          RecordParser::Parsers::Delimited.new(/ *\| */),
          RecordParser::Parsers::Delimited.new(/ *, */),
          RecordParser::Parsers::Delimited.new(/ +/),
        ]

        RecordParser::Parsers::TryMultiple.new(*component_parsers)
      end
    end

    def run_cmdline(argv, out:, err:)
      options, files = parse_options(argv)
      formatter = create_formatter(options[:outform])
      if formatter.nil?
        err.puts("Error: invalid outform given.")
        return 1
      end

      sort_proc = RecordSet::SORT_ORDERS[options[:sort]]
      if sort_proc.nil?
        err.puts("Error: invalid sort option given.")
        return 1
      end

      records = RecordSet.new(sort_by: sort_proc)

      files.each do |filename|
        File.open(filename, "r") do |file_handle|
          while not file_handle.eof?
            record_text = file_handle.readline.chomp
            record = parser.parse(record_text)

            if record
              records.add_record(record)
            else
              err.puts("Error: unable to parse record in #{filename} line #{file_handle.lineno}.")
              return 2
            end
          end
        end
      end

      records.list_records.each do |record|
        out.puts formatter.format(record)
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
