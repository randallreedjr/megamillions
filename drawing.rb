require_relative "ticket.rb"

class Drawing

  attr_accessor :date, :numbers, :megaball, :megaplier, :matching_numbers, :megaball_match
  attr_reader :jackpot

  def initialize
    @date = ""
    @numbers = []
    @megaball = 0
    @megaplier = ""
    @megaball_match = false
    @jackpot = 10_000_000
  end

  def check_numbers(ticket)
      if ticket.date != date
        return 0
      end
      @matching_numbers = 0
      ticket.numbers.each do |number|        
        @matching_numbers += 1 if numbers.include?(number)
      end
      @megaball_match = (ticket.megaball == megaball)
      @ticket_megaplier = ticket.megaplier?
  end

  def calc_winnings
    @ticket_megaplier ? multiplier = @megaplier.to_i : multiplier = 1
    case megaball_match
    when true
      case matching_numbers
      when 0
        return 1 * multiplier
      when 1
        return 2 * multiplier
      when 2
        return 5 * multiplier
      when 3
        return 50 * multiplier
      when 4
        return 5_000 * multiplier
      when 5
        #No way to know the actual jackpot amount
        return @jackpot
      end
    when false
      case matching_numbers
      when 0, 1, 2
        return 0
      when 3
        return 5 * multiplier
      when 4
        return 500 * multiplier
      when 5
        return 1_000_000 * multiplier
      end
    end
    return 0
  end
end