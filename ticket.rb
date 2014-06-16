class Ticket
  attr_accessor :date, :numbers, :megaball, :megaplier

  def initialize
    @date = ""
    @numbers = []
    @megaball = 0
    @megaplier = false
  end

  def megaplier?
    @megaplier
  end
end