require "spec_helper"

describe RecordParser::Parsers::Delimited do
  it "can parse pipe separated input" do
    pipe_parser = RecordParser::Parsers::Delimited.new(/ *\| */)
    expect(pipe_parser.parse("Last | First | male | green | 1/2/2000")).to eq(RecordParser::Record.new(["Last", "First", :male, "green", Date.new(2000, 1, 2)]))
  end

  it "can parse comma separated input" do
    comma_parser = RecordParser::Parsers::Delimited.new(/ *, */)
    expect(comma_parser.parse("Last, First, male, green, 1/3/2001")).to eq(RecordParser::Record.new(["Last", "First", :male, "green", Date.new(2001, 1, 3)]))
  end

  it "can parse space separated input" do
    space_parser = RecordParser::Parsers::Delimited.new(/ +/)
    expect(space_parser.parse("Last First male green 1/4/2002")).to eq(RecordParser::Record.new(["Last", "First", :male, "green", Date.new(2002, 1, 4)]))
  end

  it "returns nil if it cannot parse given input" do
    pipe_parser = RecordParser::Parsers::Delimited.new(/ *\| */)
    expect(pipe_parser.parse("Last, First, male, green, 1/3/2001")).to be_nil
  end
end
