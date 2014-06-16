require_relative 'powerball_scraper.rb'
require_relative 'drawing.rb'
require_relative 'ticket.rb'

def run
  puts "Welcome to Mega Millions checker. Good luck!"
  scraper = MegaMillionsScraper.new
  puts "Loading drawing results..."
  scraper.scrape()
  ticket = Ticket.new
  puts "What date was your drawing?"
  #To Do - Normalize Date
  ticket.date = normalize_date(gets.chomp)
  puts "Enter your five regular numbers"
  ticket.numbers = gets.chomp.split(" ")
  puts "Enter your mega ball number"
  ticket.powerball = gets.chomp
  puts "Did you select megaplier? (y/n)"
  ticket.powerplay = (gets.chomp.downcase == "y")

  scraper.drawings.each do |drawing|
    if drawing.date == ticket.date
      drawing.check_numbers(ticket)
      winnings = drawing.calc_winnings
      if winnings > 0
        if winnings == drawing.jackpot
          puts "YOU HIT THE JACKPOT!!! Check the Mega Millions site for your official winnings amount."
        else
          puts "Congrats! You won #{winnings}!"
        end
      else
        puts "Sorry, you didn't win this time. Better luck next time."
      end
    end
  end
end

def normalize_date(date)
  date.gsub!(/\b0/,"").gsub!(/\d{2,4}\z/,"20#{date[-2..-1]}")
end

run()