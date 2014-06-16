require_relative 'spec_helper.rb'

describe MegaMillionsScraper do 
  it "should retrieve the most recent drawing results" do
    scraper = MegaMillionsScraper.new()
    scraper.scrape
    tuesday = Chronic.parse("last tuesday")
    friday = Chronic.parse("last friday")

    tuesday > friday ? date = "#{tuesday.mon}/#{tuesday.day}/#{tuesday.year}" : 
                           date = "#{friday.mon}/#{friday.day}/#{friday.year}"
    expect(scraper.drawings.first.date).to eq(date)
  end

  context "calculating winnings" do
    before(:all) do
      @drawing = Drawing.new
      @ticket = Ticket.new
      @drawing.date, @ticket.date = "6/14/2014", "6/14/2014"
      @drawing.numbers = "1 2 3 4 5".split(" ")
      @drawing.megaball = "6"
      @drawing.megaplier = "2x"
    end

    it "should return zero if no numbers match" do
      @ticket.numbers = "7 8 9 10 11".split(" ")
      @ticket.megaball = "12"
      @ticket.megaplier = false
      @drawing.check_numbers(@ticket)
      expect(@drawing.calc_winnings()).to eq(0)
    end

    it "should not match a regular number to the megaball" do
      @ticket.numbers = "6 7 8 9 10".split(" ")
      @ticket.megaball = "11"
      @ticket.megaplier = false
      @drawing.check_numbers(@ticket)
      expect(@drawing.calc_winnings()).to eq(0)
    end

    it "should return zero if one regular number matches" do
      @ticket.numbers = "5 7 8 9 10".split(" ")
      @ticket.megaball = "12"
      @ticket.megaplier = false
      @drawing.check_numbers(@ticket)
      expect(@drawing.calc_winnings()).to eq(0)
    end

    it "should return zero if two regular numbers match" do
      @ticket.numbers = "4 5 7 8 9".split(" ")
      @ticket.megaball = "12"
      @ticket.megaplier = false
      @drawing.check_numbers(@ticket)
      expect(@drawing.calc_winnings()).to eq(0)
    end

    it "should return five if three regular numbers match" do
      @ticket.numbers = "3 4 5 7 8".split(" ")
      @ticket.megaball = "12"
      @ticket.megaplier = false
      @drawing.check_numbers(@ticket)
      expect(@drawing.calc_winnings()).to eq(5)
    end

    it "should return five hundred if four regular numbers match" do
      @ticket.numbers = "2 3 4 5 7".split(" ")
      @ticket.megaball = "12"
      @ticket.megaplier = false
      @drawing.check_numbers(@ticket)
      expect(@drawing.calc_winnings()).to eq(500)
    end

    it "should return one million if all five regular numbers match" do
      @ticket.numbers = "1 2 3 4 5".split(" ")
      @ticket.megaball = "12"
      @ticket.megaplier = false
      @drawing.check_numbers(@ticket)
      expect(@drawing.calc_winnings()).to eq(1_000_000)
    end

    it "should return one if only megaball matches" do
      @ticket.numbers = "7 8 9 10 11".split(" ")
      @ticket.megaball = "6"
      @ticket.megaplier = false
      @drawing.check_numbers(@ticket)
      expect(@drawing.calc_winnings()).to eq(1)
    end

    it "should return two if megaball and one other number matches" do
      @ticket.numbers = "1 7 8 9 10".split(" ")
      @ticket.megaball = "6"
      @ticket.megaplier = false
      @drawing.check_numbers(@ticket)
      expect(@drawing.calc_winnings()).to eq(2)
    end

    it "should return five if megaball and two other numbers match" do
      @ticket.numbers = "1 2 7 8 9".split(" ")
      @ticket.megaball = "6"
      @ticket.megaplier = false
      @drawing.check_numbers(@ticket)
      expect(@drawing.calc_winnings()).to eq(5)
    end

    it "should return fifty if megaball and three other numbers match" do
      @ticket.numbers = "1 2 3 7 8".split(" ")
      @ticket.megaball = "6"
      @ticket.megaplier = false
      @drawing.check_numbers(@ticket)
      expect(@drawing.calc_winnings()).to eq(50)
    end

    it "should return five thousand if megaball and four other numbers match" do
      @ticket.numbers = "1 2 3 4 7".split(" ")
      @ticket.megaball = "6"
      @ticket.megaplier = false
      @drawing.check_numbers(@ticket)
      expect(@drawing.calc_winnings()).to eq(5_000)
    end

    it "should return jackpot if megaball and five other numbers match" do
      @ticket.numbers = "1 2 3 4 5".split(" ")
      @ticket.megaball = "6"
      @ticket.megaplier = false
      @drawing.check_numbers(@ticket)
      expect(@drawing.calc_winnings()).to eq(@drawing.jackpot)
    end

    context "megaplier" do
      before(:all) do
        @ticket.megaplier = true
      end
      it "should multiply winnings by megaplier without megaball" do
        @ticket.numbers = "1 2 3 7 8".split(" ")
        @ticket.megaball = "12"
        @drawing.megaplier = "3X"
        @drawing.check_numbers(@ticket)
        expect(@drawing.calc_winnings()).to eq(15)
      end

      it "should multiply winnings by megaplier with megaball" do
        @ticket.numbers = "1 2 3 7 8".split(" ")
        @ticket.megaball = "6"
        @drawing.megaplier = "5X"
        @drawing.check_numbers(@ticket)
        expect(@drawing.calc_winnings()).to eq(250)
      end

      it "should not affect jackpot" do
        @ticket.numbers = "1 2 3 4 5".split(" ")
        @ticket.megaball = "6"
        @drawing.megaplier = "2X"
        @drawing.check_numbers(@ticket)
        expect(@drawing.calc_winnings()).to eq(@drawing.jackpot)
      end

      it "should not max out at two million" do
        @ticket.numbers = "1 2 3 4 5".split(" ")
        @ticket.megaball = "12"
        @drawing.megaplier = "4X"
        @drawing.check_numbers(@ticket)
        expect(@drawing.calc_winnings()).to eq(4_000_000)
      end
    end
  end
end