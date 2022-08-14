=begin

Nouns: player, game
Verbs: bet, roll dice

game
  - roll dice
  - settle bet

player
  - place bet
  - check if player is going bankrupt

7 up 7 Down - Game Introduction:
A pair of dice is rolled by the dealer
The result options as a result are (2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
Player places bets on the three following options
7 down (2, 3, 4, 5, 6) - payout 1 : 1
7 up (8, 9, 10, 11, 12) - payout 1 : 1
Number 7 (7) - payout 4 : 1
The bets are settled according to the results
Game continues till the player decides to leave or goes bankrupt

Options -
You can have a fixed wallet amount for a player to start with or have them enter a custom amount
The bet can have a minimum and might be forced in round numbers or multiples of 5
Pauses can be introduced between the gameplay to simulate the rolling of a dice

add a new window that opens and make more user friendly

=end
# language problem: distinguish between choosing money to bet and placing bet on outcome

class Player
  def initialize(initial_wallet_amount)
    @wallet = initial_wallet_amount
    @bet = nil
    @guess = nil
  end

  def place_guess
    choice = nil
    loop do
      puts "Now place your guess:"
      puts "1. \t 7 up(8, 9, 10, 11, 12)"
      puts "2. \t 7 down(2, 3, 4, 5, 6)"
      puts "3. \t 7"
      choice = gets.chomp.to_i
      break if valid_guess?(choice)
      puts "Sorry, you must enter 1, 2, or 3."
    end
    self.guess = choice
    nil
  end

  def valid_guess?(guess)
    (1..3).include?(guess)
  end


  # choose the amount of money that the player wants to bet
  def place_bet
    choice = nil
    loop do
      puts "How much money would you like to wager?"
      display_wallet
      choice = gets.chomp.to_f

      break if valid_bet?(choice)
      
      if choice > wallet
        puts "Sorry, you don't have enough money to bet that much."
      elsif choice <= 0
        puts "Sorry, you must bet a positive number."
      else
        puts "error....."
      end
    end
    self.bet = choice
    self.wallet -= choice
    nil
  end

  # check if bet 
  def valid_bet?(bet)
    bet < wallet && bet > 0
  end

  def bankrupt?

  end

  def settle_bet(outcome)
    if win?(outcome) && (guess == 2) # if player guessed 7 and correct
      self.wallet += (bet*5)
      puts "You won!"
    elsif win?(outcome) # if player guessed correct but not 7
      self.wallet += (bet*2)
      puts "You won!"
    else
      puts "You lost..."
    end
  end

  def win?(outcome)
    (guess == 1 && outcome > 7) || # player bet 7 up and answer was above 7
    (guess == 2 && outcome < 7) || # player bet 7 down and answer was below 7
    (guess == 3 && outcome == 7) # player bet 7 and answer was 7
  end

  def display_wallet
    puts format("(Wallet: $%.2f)", wallet)
  end

  private

  attr_accessor :bet, :guess, :wallet
end


class SevenUpSevenDownGame
  INITIAL_WALLET_AMOUNT = 100.00 # determines how much money the player starts with

  def initialize
    @player = Player.new(INITIAL_WALLET_AMOUNT)
  end

  def display_welcome_message
    puts "Welcome to Seven Up Seven Down!"
  end

  def display_ending_message
    puts "Thanks for playing Seven Up Seven Down! Goodbye."
    puts player.display_wallet
  end

  def play
    display_welcome_message
    player.place_bet
    player.place_guess
    player.settle_bet(roll_dice)
    display_ending_message
  end

  def roll_dice
    rand(2..12)
  end


  def settle_bet(player, outcome)

  end

  def calc_payout

  end

  private
  attr_reader :player
end

SevenUpSevenDownGame.new.play