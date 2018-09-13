require "spec_helper"

describe RecordParser::Formatter do
  it "can create pipe separated output" do
    pipe_formatter = RecordParser::Formatter.new(" | ")
    expect(pipe_formatter.format(RecordParser::Record.new(["Last", "First", :male, "green", Date.new(2000, 1, 2)]))).to eq("Last | First | male | green | 1/2/2000")
  end

  it "can create comma separated output" do
    comma_formatter = RecordParser::Formatter.new(", ")
    expect(comma_formatter.format(RecordParser::Record.new(["Last", "First", :male, "green", Date.new(2001, 1, 3)]))).to eq("Last, First, male, green, 1/3/2001")
  end

  it "can create space separated output" do
    space_formatter = RecordParser::Formatter.new(" ")
    expect(space_formatter.format(RecordParser::Record.new(["Last", "First", :male, "green", Date.new(2002, 1, 4)]))).to eq("Last First male green 1/4/2002")
  end
end
