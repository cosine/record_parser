require "spec_helper"

describe RecordParser::Parsers::TryMultiple do
  subject do
    pipe_parser = RecordParser::Parsers::Delimited.new(/ *\| */)
    comma_parser = RecordParser::Parsers::Delimited.new(/ *, */)
    space_parser = RecordParser::Parsers::Delimited.new(/ +/)
    RecordParser::Parsers::TryMultiple.new(pipe_parser, comma_parser, space_parser)
  end

  it "can parse pipe separated input" do
    expect(subject.parse("Last | First | male | green | 1/2/2000")).to eq(RecordParser::Record.new(["Last", "First", :male, "green", Date.new(2000, 1, 2)]))
  end

  it "can parse comma separated input" do
    expect(subject.parse("Last, First, male, green, 1/3/2001")).to eq(RecordParser::Record.new(["Last", "First", :male, "green", Date.new(2001, 1, 3)]))
  end

  it "can parse space separated input" do
    expect(subject.parse("Last First male green 1/4/2002")).to eq(RecordParser::Record.new(["Last", "First", :male, "green", Date.new(2002, 1, 4)]))
  end
end
