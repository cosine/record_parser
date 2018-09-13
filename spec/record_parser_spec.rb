require "spec_helper"

describe RecordParser do
  describe ".run_cmdline" do
    it "reads 3 formats of input and can sort comma delimited output by option1, gender then last name" do
      argv = [
        "spec/data/pipe_delimited_2.txt",
        "spec/data/pipe_delimited_1.txt",
        "spec/data/comma_delimited_1.txt",
        "spec/data/space_delimited_1.txt",
        "--sort", "option1",
        "--outform", "comma_delimited",
      ]

      out_buffer = StringIO.new
      err_buffer = StringIO.new
      RecordParser.run_cmdline(argv, out: out_buffer, err: err_buffer)

      expect(out_buffer.string).to eq(<<-EOF.gsub(/^ */, ""))
        Carlisle, Eva, female, white, 6/12/1995
        Davidson, Candice, female, yellow, 9/10/1997
        Piper, Alice, female, red, 2/28/1993
        Random, Danielle, female, purple, 4/23/1997
        Rogers, Lisa, female, blue, 12/31/1975
        Adamson, Zachary, male, blue, 3/5/2000
        Quorum, Bob, male, green, 10/11/1992
        Still, Charlie, male, fuschia, 1/4/1986
        Venti, Harry, male, brown, 12/3/1994
        Yender, Hachi, male, pink, 7/6/1999
        Shephard, Pat, other, red, 9/9/1999
      EOF

      expect(err_buffer.size).to be_zero
    end

    it "reads 3 formats of input and can sort space delimited output by option2, birth date" do
      argv = [
        "spec/data/pipe_delimited_2.txt",
        "spec/data/pipe_delimited_1.txt",
        "spec/data/comma_delimited_1.txt",
        "spec/data/space_delimited_1.txt",
        "--sort", "option2",
        "--outform", "space_delimited",
      ]

      out_buffer = StringIO.new
      err_buffer = StringIO.new
      RecordParser.run_cmdline(argv, out: out_buffer, err: err_buffer)

      expect(out_buffer.string).to eq(<<-EOF.gsub(/^ */, ""))
        Rogers Lisa female blue 12/31/1975
        Still Charlie male fuschia 1/4/1986
        Quorum Bob male green 10/11/1992
        Piper Alice female red 2/28/1993
        Venti Harry male brown 12/3/1994
        Carlisle Eva female white 6/12/1995
        Random Danielle female purple 4/23/1997
        Davidson Candice female yellow 9/10/1997
        Yender Hachi male pink 7/6/1999
        Shephard Pat other red 9/9/1999
        Adamson Zachary male blue 3/5/2000
      EOF

      expect(err_buffer.size).to be_zero
    end

    it "reads 3 formats of input and can sort pipe delimited output by option3, last name reversed" do
      argv = [
        "spec/data/pipe_delimited_2.txt",
        "spec/data/pipe_delimited_1.txt",
        "spec/data/comma_delimited_1.txt",
        "spec/data/space_delimited_1.txt",
        "--sort", "option3",
        "--outform", "pipe_delimited",
      ]

      out_buffer = StringIO.new
      err_buffer = StringIO.new
      RecordParser.run_cmdline(argv, out: out_buffer, err: err_buffer)

      expect(out_buffer.string).to eq(<<-EOF.gsub(/^ */, ""))
        Yender | Hachi | male | pink | 7/6/1999
        Venti | Harry | male | brown | 12/3/1994
        Still | Charlie | male | fuschia | 1/4/1986
        Shephard | Pat | other | red | 9/9/1999
        Rogers | Lisa | female | blue | 12/31/1975
        Random | Danielle | female | purple | 4/23/1997
        Quorum | Bob | male | green | 10/11/1992
        Piper | Alice | female | red | 2/28/1993
        Davidson | Candice | female | yellow | 9/10/1997
        Carlisle | Eva | female | white | 6/12/1995
        Adamson | Zachary | male | blue | 3/5/2000
      EOF

      expect(err_buffer.size).to be_zero
    end

    it "errors with invalid input" do
      argv = [
        "spec/data/pipe_delimited_2.txt",
        "spec/data/pipe_delimited_1.txt",
        "spec/data/comma_delimited_1.txt",
        "spec/data/space_delimited_1.txt",
        "spec/data/erroneous_data.txt",
        "--sort", "option1",
        "--outform", "comma_delimited",
      ]

      out_buffer = StringIO.new
      err_buffer = StringIO.new
      RecordParser.run_cmdline(argv, out: out_buffer, err: err_buffer)

      expect(out_buffer.size).to be_zero
      expect(err_buffer.string).to match(%r"unable to parse record in spec/data/erroneous_data.txt line 1")
    end

    it "errors with an invalid sort option" do
      argv = [
        "spec/data/pipe_delimited_2.txt",
        "spec/data/pipe_delimited_1.txt",
        "spec/data/comma_delimited_1.txt",
        "spec/data/space_delimited_1.txt",
        "--sort", "invalid",
        "--outform", "comma_delimited",
      ]

      out_buffer = StringIO.new
      err_buffer = StringIO.new
      RecordParser.run_cmdline(argv, out: out_buffer, err: err_buffer)

      expect(out_buffer.size).to be_zero
      expect(err_buffer.string).to match(/invalid sort option/)
    end

    it "errors with an invalid outform option" do
      argv = [
        "spec/data/pipe_delimited_2.txt",
        "spec/data/pipe_delimited_1.txt",
        "spec/data/comma_delimited_1.txt",
        "spec/data/space_delimited_1.txt",
        "--sort", "option1",
        "--outform", "invalid_outform",
      ]

      out_buffer = StringIO.new
      err_buffer = StringIO.new
      RecordParser.run_cmdline(argv, out: out_buffer, err: err_buffer)

      expect(out_buffer.size).to be_zero
      expect(err_buffer.string).to match(/outform/)
    end
  end
end
