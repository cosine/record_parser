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

    def json_response(http_status, data_structure)
      [http_status, {"Content-Type" => "application/json"}, RecordParser::JsonFormatter.jsonify(data_structure)]
    end

    post "/records" do
      record = RecordParser.parser.parse(request.body.read)

      if record
        self.class.records_option1.add_record(record)
        self.class.records_option2.add_record(record)
        self.class.records_option3.add_record(record)
        json_response(201, record: record)
      else
        json_response(400, error: "Error: unable to parse record.")
      end
    end

    get "/records/gender" do
      records = self.class.records_option1.list_records
      json_response(200, records: records)
    end

    get "/records/birthdate" do
      records = self.class.records_option2.list_records
      json_response(200, records: records)
    end

    get "/records/name" do
      records = self.class.records_option3.list_records
      json_response(200, records: records)
    end
  end
end
