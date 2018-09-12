require "optparse"

class RecordParser
  class << self
    def run_cmdline(argv, out:, err:)
      options, files = parse_options(argv)
      records = RecordSet.new(sort_by: Record::SORT_ORDERS[options[:sort]])

      files.each do |filename|
        File.open(filename, "r") do |file_handle|
          while not file_handle.eof?
            record_text = file_handle.readline.chomp
            # TODO: identify format and parse
          end
        end
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

require "record_parser/record"
require "record_parser/record_set"
require "record_parser/parsers/pipe_delimited"
require "record_parser/parsers/comma_delimited"
require "record_parser/parsers/space_delimited"
