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
+ You can have a fixed wallet amount for a player to start with or have them enter a custom amount
+ The bet can have a minimum and might be forced in round numbers or multiples of 5
Pauses can be introduced between the gameplay to simulate the rolling of a dice

add a new window that opens and make more user friendly

rubocop the final product
=end
# language problem: distinguish between choosing money to bet and placing bet on outcome

class Player
  INITIAL_WALLET_AMOUNT = 100.00

  def initialize
    @wallet = INITIAL_WALLET_AMOUNT
    @bet = nil
    @guess = nil
  end

  def place_guess
    choice = nil
    loop do
      puts "Now place your guess:"
      puts "1. 7 up(8, 9, 10, 11, 12)"
      puts "2. 7 down(2, 3, 4, 5, 6)"
      puts "3. 7"
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
      elsif choice < SevenUpSevenDownGame::MINIMUM_BET_AMOUNT
        puts format("Sorry, you must bet more than $%.2f", SevenUpSevenDownGame::MINIMUM_BET_AMOUNT)
      elsif ((choice % 5) != 0)
        puts "Sorry, you can only bet on multiples of 5."
      else
        puts "error....."
      end
    end
    self.bet = choice
    self.wallet -= choice
    nil
  end

  # check if player can afford bet and bet is positive
  def valid_bet?(choice)
    choice <= wallet && choice >= SevenUpSevenDownGame::MINIMUM_BET_AMOUNT && choice % 5 == 0
  end

  def receive_payout(multiplier: 1)
    self.wallet += bet * multiplier
  end

  def guessed_seven_up?
    guess == 1
  end

  def guessed_seven_down?
    guess == 2
  end

  def guessed_seven?
    guess == 3
  end

  def bankrupt?

  end

  def display_wallet
    puts format("(Wallet: $%.2f)", wallet)
  end
  attr_accessor :bet

  private

  attr_accessor :guess, :wallet
end

class SevenUpSevenDownGame
  MINIMUM_BET_AMOUNT = 5.0

  def initialize
    @player = Player.new
    @outcome = nil
  end

  def play
    display_welcome_message
    run_main_game
    display_ending_message
  end

  def run_main_game
    loop do
      player.place_bet
      player.place_guess
      roll_dice!
      settle_bet
      break unless play_again?
    end
  end

  def pause_and_clear_screen
    sleep(2)
    system 'clear'
  end

  def display_welcome_message
    puts "Welcome to Seven Up Seven Down!"
    pause_and_clear_screen
  end

  def display_ending_message
    puts "Thanks for playing Seven Up Seven Down! Goodbye."
    puts player.display_wallet
  end

  def roll_dice!
    self.outcome = rand(2..12)
    puts "The dice was rolled! The outcome is #{outcome}!"
    pause_and_clear_screen
  end

  def play_again?
    choice = nil
    loop do
      puts "Would you like to play again? (y or n)"
      choice = gets.chomp
      break if (choice == 'y' || choice == 'n')
      puts "Invalid choice. Must input either y or n."
    end
    choice == 'y'
  end

  def settle_bet
    if win?
      puts "You won!"
      puts format("You received your $%.2f bet back.", player.bet)
      if player.guessed_seven?
        player.receive_payout(multiplier: 5)
        puts format("You also earned $%.2f profit", (player.bet * 5))
      else
        player.receive_payout(multiplier: 2)
        puts format("You also earned $%.2f profit", (player.bet * 5))
      end
    else
      puts format("You lost... You are down $%.2f.", player.bet)
    end
    player.display_wallet
    pause_and_clear_screen
  end

  def win?
    (player.guessed_seven_up? && outcome > 7) || # player bet 7 up and answer was above 7
    (player.guessed_seven_down? && outcome < 7) || # player bet 7 down and answer was below 7
    (player.guessed_seven? && outcome == 7) # player bet 7 and answer was 7
  end

  private
  attr_reader :player
  attr_accessor :outcome
end

SevenUpSevenDownGame.new.play