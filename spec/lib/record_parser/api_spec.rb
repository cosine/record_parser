require "spec_helper"
require "record_parser/api"

describe RecordParser::API do
  include Rack::Test::Methods

  let(:app) { RecordParser::API }

  after { app.reset_records! }

  describe "POST /records" do
    it "loads a pipe delimited record" do
      expect { expect { expect {
        post "/records", "Palgo | George | male | green | 10/8/1984"
        expect(last_response.status).to eq(201)
      }.to change(app.records_option1, :list_records).from([]).to([RecordParser::Record.new(["Palgo", "George", :male, "green", Date.new(1984, 10, 8)])])
      }.to change(app.records_option2, :list_records).from([]).to([RecordParser::Record.new(["Palgo", "George", :male, "green", Date.new(1984, 10, 8)])])
      }.to change(app.records_option3, :list_records).from([]).to([RecordParser::Record.new(["Palgo", "George", :male, "green", Date.new(1984, 10, 8)])])
    end

    it "loads a comma delimited record" do
      expect { expect { expect {
        post "/records", "Rogers, Lisa, female, blue, 12/31/1975"
        expect(last_response.status).to eq(201)
      }.to change(app.records_option1, :list_records).from([]).to([RecordParser::Record.new(["Rogers", "Lisa", :female, "blue", Date.new(1975, 12, 31)])])
      }.to change(app.records_option2, :list_records).from([]).to([RecordParser::Record.new(["Rogers", "Lisa", :female, "blue", Date.new(1975, 12, 31)])])
      }.to change(app.records_option3, :list_records).from([]).to([RecordParser::Record.new(["Rogers", "Lisa", :female, "blue", Date.new(1975, 12, 31)])])
    end

    it "loads a space delimited record" do
      expect { expect { expect {
        post "/records", "Guild Sarah female red 7/26/1980"
        expect(last_response.status).to eq(201)
      }.to change(app.records_option1, :list_records).from([]).to([RecordParser::Record.new(["Guild", "Sarah", :female, "red", Date.new(1980, 7, 26)])])
      }.to change(app.records_option2, :list_records).from([]).to([RecordParser::Record.new(["Guild", "Sarah", :female, "red", Date.new(1980, 7, 26)])])
      }.to change(app.records_option3, :list_records).from([]).to([RecordParser::Record.new(["Guild", "Sarah", :female, "red", Date.new(1980, 7, 26)])])
    end

    it "400s on invalid input" do
      expect { expect { expect {
        post "/records", "Guild Sarah, female blue | 7/26/1980"
        expect(last_response.status).to eq(400)
      }.not_to change(app.records_option1, :list_records).from([])
      }.not_to change(app.records_option2, :list_records).from([])
      }.not_to change(app.records_option3, :list_records).from([])
    end
  end

  describe "GET /records/gender" do
  end

  describe "GET /records/birthdate" do
  end

  describe "GET /records/name" do
  end
end
