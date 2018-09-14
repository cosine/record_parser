require "spec_helper"

describe RecordParser::Record do
  it "assigns last name, first name, and favorite color correctly" do
    record = RecordParser::Record.new(["Last", "First", "male", "green", "3/5/1999"])
    expect(record.last_name).to eq("Last")
    expect(record.first_name).to eq("First")
    expect(record.favorite_color).to eq("green")
  end

  it "parses String inputs correctly with US dates" do
    record = RecordParser::Record.new(["Last", "First", "male", "green", "3/5/1999"])
    expect(record.birth_date).to eq(Date.new(1999, 3, 5))
  end

  it "parses String inputs correctly with dash format dates" do
    record = RecordParser::Record.new(["Last", "First", "male", "green", "1997-06-15"])
    expect(record.birth_date).to eq(Date.new(1997, 6, 15))
  end

  it "passes a Date object through correctly" do
    record = RecordParser::Record.new(["Last", "First", "male", "green", Date.new(1994, 12, 31)])
    expect(record.birth_date).to eq(Date.new(1994, 12, 31))
  end

  it "parses female gender correctly" do
    record = RecordParser::Record.new(["Last", "First", "female", "green", "3/5/1999"])
    expect(record.gender).to eq(:female)
  end

  it "parses male gender correctly" do
    record = RecordParser::Record.new(["Last", "First", "male", "green", "3/5/1999"])
    expect(record.gender).to eq(:male)
  end

  it "parses other gender correctly" do
    record = RecordParser::Record.new(["Last", "First", "unknown", "green", "3/5/1999"])
    expect(record.gender).to eq(:other)
  end

  describe "#to_json" do
    it "creates proper JSON" do
      record = RecordParser::Record.new(["Last", "First", :male, "green", Date.new(1999, 11, 3)])
      expect(record.to_json).to eq('{"last_name":"Last","first_name":"First","gender":"male","favorite_color":"green","birth_date":"1999-11-03"}')
    end
  end
end
