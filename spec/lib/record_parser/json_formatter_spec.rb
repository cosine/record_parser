require "spec_helper"

describe RecordParser::JsonFormatter do
  describe ".jsonify" do
    it "creates proper JSON for a Record" do
      record = RecordParser::Record.new(["Last", "First", :male, "green", Date.new(1999, 11, 3)])
      expect(RecordParser::JsonFormatter.jsonify(record)).to eq('{"last_name":"Last","first_name":"First","gender":"male","favorite_color":"green","birth_date":"1999-11-03"}')
    end

    it "creates proper JSON for Hash of things" do
      expect(RecordParser::JsonFormatter.jsonify(a: 1, b: "two", c: [:x, :y, :z])).to eq('{"a":1,"b":"two","c":["x","y","z"]}')
    end
  end

  describe ".json_structure_for" do
    it "creates proper JSON structure for a Record" do
      record = RecordParser::Record.new(["Last", "First", :male, "green", Date.new(1999, 11, 3)])
      expected_structure = {
        "last_name" => "Last",
        "first_name" => "First",
        "gender" => "male",
        "favorite_color" => "green",
        "birth_date" => Date.new(1999, 11, 3),
      }
      expect(RecordParser::JsonFormatter.json_structure_for(record)).to eq(expected_structure)
    end

    it "creates proper JSON structure for Hash of things" do
      original_structure = {a: 1, b: "two", c: [:x, :y, :z]}
      expected_structure = {"a" => 1, "b" => "two", "c" => ["x", "y", "z"]}
      expect(RecordParser::JsonFormatter.json_structure_for(original_structure)).to eq(expected_structure)
    end
  end
end
