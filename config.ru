$LOAD_PATH.unshift(File.expand_path("../lib", __FILE__))
require "record_parser"
require "record_parser/api"

run RecordParser::API
