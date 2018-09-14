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

      expect(last_response.body).to eq(<<-EOF.strip)
        {"record":{"last_name":"Palgo","first_name":"George","gender":"male","favorite_color":"green","birth_date":"1984-10-08"}}
      EOF
    end

    it "loads a comma delimited record" do
      expect { expect { expect {
        post "/records", "Rogers, Lisa, female, blue, 12/31/1975"
        expect(last_response.status).to eq(201)
      }.to change(app.records_option1, :list_records).from([]).to([RecordParser::Record.new(["Rogers", "Lisa", :female, "blue", Date.new(1975, 12, 31)])])
      }.to change(app.records_option2, :list_records).from([]).to([RecordParser::Record.new(["Rogers", "Lisa", :female, "blue", Date.new(1975, 12, 31)])])
      }.to change(app.records_option3, :list_records).from([]).to([RecordParser::Record.new(["Rogers", "Lisa", :female, "blue", Date.new(1975, 12, 31)])])

      expect(last_response.body).to eq(<<-EOF.strip)
        {"record":{"last_name":"Rogers","first_name":"Lisa","gender":"female","favorite_color":"blue","birth_date":"1975-12-31"}}
      EOF
    end

    it "loads a space delimited record" do
      expect { expect { expect {
        post "/records", "Guild Sarah female red 7/26/1980"
        expect(last_response.status).to eq(201)
      }.to change(app.records_option1, :list_records).from([]).to([RecordParser::Record.new(["Guild", "Sarah", :female, "red", Date.new(1980, 7, 26)])])
      }.to change(app.records_option2, :list_records).from([]).to([RecordParser::Record.new(["Guild", "Sarah", :female, "red", Date.new(1980, 7, 26)])])
      }.to change(app.records_option3, :list_records).from([]).to([RecordParser::Record.new(["Guild", "Sarah", :female, "red", Date.new(1980, 7, 26)])])

      expect(last_response.body).to eq(<<-EOF.strip)
        {"record":{"last_name":"Guild","first_name":"Sarah","gender":"female","favorite_color":"red","birth_date":"1980-07-26"}}
      EOF
    end

    it "400s on invalid input" do
      expect { expect { expect {
        post "/records", "Guild Sarah, female blue | 7/26/1980"
        expect(last_response.status).to eq(400)
      }.not_to change(app.records_option1, :list_records).from([])
      }.not_to change(app.records_option2, :list_records).from([])
      }.not_to change(app.records_option3, :list_records).from([])

      expect(last_response.body).to eq(<<-EOF.strip)
        {"error":"Error: unable to parse record."}
      EOF
    end
  end

  describe do
    # In this block we will preload some records using the POST endpoint.
    before do
      post "/records", "Hamster, John, male, brown, 1999-1-5"
      post "/records", "Zeo, Jane, female, pink, 1998-11-23"
      post "/records", "Hall, Cara, female, red, 2001-4-8"
      post "/records", "York, Bob, male, green, 2000-9-5"
      post "/records", "Bright, Lisa, female, purple, 2003-10-7"
      post "/records", "Allenson, Adam, male, yellow, 1992-6-2"
    end

    describe "GET /records/gender" do
      it "returns records in gender order" do
        get "/records/gender"
        expect(last_response.status).to eq(200)

        expect(last_response.body).to eq(<<-EOF.strip.split(/\n\s+/).join)
          {"records":[
            {"last_name":"Bright","first_name":"Lisa","gender":"female","favorite_color":"purple","birth_date":"2003-10-07"},
            {"last_name":"Hall","first_name":"Cara","gender":"female","favorite_color":"red","birth_date":"2001-04-08"},
            {"last_name":"Zeo","first_name":"Jane","gender":"female","favorite_color":"pink","birth_date":"1998-11-23"},
            {"last_name":"Allenson","first_name":"Adam","gender":"male","favorite_color":"yellow","birth_date":"1992-06-02"},
            {"last_name":"Hamster","first_name":"John","gender":"male","favorite_color":"brown","birth_date":"1999-01-05"},
            {"last_name":"York","first_name":"Bob","gender":"male","favorite_color":"green","birth_date":"2000-09-05"}
          ]}
        EOF
      end
    end

    describe "GET /records/birthdate" do
      it "returns records in birth date order" do
        get "/records/birthdate"
        expect(last_response.status).to eq(200)

        expect(last_response.body).to eq(<<-EOF.strip.split(/\n\s+/).join)
          {"records":[
            {"last_name":"Allenson","first_name":"Adam","gender":"male","favorite_color":"yellow","birth_date":"1992-06-02"},
            {"last_name":"Zeo","first_name":"Jane","gender":"female","favorite_color":"pink","birth_date":"1998-11-23"},
            {"last_name":"Hamster","first_name":"John","gender":"male","favorite_color":"brown","birth_date":"1999-01-05"},
            {"last_name":"York","first_name":"Bob","gender":"male","favorite_color":"green","birth_date":"2000-09-05"},
            {"last_name":"Hall","first_name":"Cara","gender":"female","favorite_color":"red","birth_date":"2001-04-08"},
            {"last_name":"Bright","first_name":"Lisa","gender":"female","favorite_color":"purple","birth_date":"2003-10-07"}
          ]}
        EOF
      end
    end

    describe "GET /records/name" do
      it "returns records in reverse name order" do
        get "/records/name"
        expect(last_response.status).to eq(200)

        expect(last_response.body).to eq(<<-EOF.strip.split(/\n\s+/).join)
          {"records":[
            {"last_name":"Zeo","first_name":"Jane","gender":"female","favorite_color":"pink","birth_date":"1998-11-23"},
            {"last_name":"York","first_name":"Bob","gender":"male","favorite_color":"green","birth_date":"2000-09-05"},
            {"last_name":"Hamster","first_name":"John","gender":"male","favorite_color":"brown","birth_date":"1999-01-05"},
            {"last_name":"Hall","first_name":"Cara","gender":"female","favorite_color":"red","birth_date":"2001-04-08"},
            {"last_name":"Bright","first_name":"Lisa","gender":"female","favorite_color":"purple","birth_date":"2003-10-07"},
            {"last_name":"Allenson","first_name":"Adam","gender":"male","favorite_color":"yellow","birth_date":"1992-06-02"}
          ]}
        EOF
      end
    end
  end
end
