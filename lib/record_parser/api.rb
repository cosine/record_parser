require "sinatra/base"

class RecordParser
  class API < Sinatra::Base
    class << self
      attr_reader :records_option1, :records_option2, :records_option3

      def reset_records!
        @records_option1 = RecordParser::RecordSet.new(sort_by: RecordParser::RecordSet::SORT_ORDERS["option1"])
        @records_option2 = RecordParser::RecordSet.new(sort_by: RecordParser::RecordSet::SORT_ORDERS["option2"])
        @records_option3 = RecordParser::RecordSet.new(sort_by: RecordParser::RecordSet::SORT_ORDERS["option3"])
      end
    end

    reset_records!

    post "/records" do
      record = RecordParser.parser.parse(request.body.read)

      if record
        self.class.records_option1.add_record(record)
        self.class.records_option2.add_record(record)
        self.class.records_option3.add_record(record)
        [201, {"Content-Type" => "application/json"}, '{record:{}}']
      else
        [400, {"Content-Type" => "application/json"}, '{error:{"Error: unable to parse record."}}']
      end
    end

    get "/records/gender" do
    end

    get "/records/birthdate" do
    end

    get "/records/name" do
    end
  end
end
