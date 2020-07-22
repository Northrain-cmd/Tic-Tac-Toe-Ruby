# frozen_string_literal: true

# creates gameboards
class Gameboard
  attr_accessor :player1, :player2
  attr_accessor :turn, :board, :mode
  def initialize(mod)
    @mode = mod
    @turn = 1
    @board = %w[1 2 3 4 5 6 7 8 9]
  end

  private

  def show_board
    puts '',
         "#{@board[0]} | #{@board[1]} | #{@board[2]}",
         '',
         "#{@board[3]} | #{@board[4]} | #{@board[5]}",
         '',
         "#{@board[6]} | #{@board[7]} | #{@board[8]}",
         ''
  end

  def change_board(position)
    @board[position] = turn == 1 ? 'X' : 'O'
  end

  def change_turn
    @turn = turn == 1 ? 2 : 1
  end

  def place_taken?(number)
    %w[X O].include?(@board[number])
  end

  def input
    text = turn == 1 ? player1.name : player2.name
    show_board
    puts "#{text}, choose a cell to place your mark"
    inp = gets.chomp
    if inp.match?(/^[1-9]$/)
      inp.to_i - 1
    else
      puts 'Invalid number'
      input
    end
  end

  def easy
    cell = rand(8)
    cell = rand(8) while place_taken?(cell)
    cell
  end

  def ai_turn
    easy
  end

  def ai_mode
    if @turn == 1
      human_turn
    else
      ai_turn
    end
  end

  def human_turn
    cell = input
    while place_taken?(cell)
      puts 'Spot taken, try another one'
      cell = input
    end
    cell
  end

  public

  def make_turn
    cell = @mode == 1 ? human_turn : ai_mode
    change_board(cell)
    show_board
    change_turn
  end
end

# creates players
class Player
  attr_reader :name
  def initialize(name)
    @name = name
  end
end

# creates an AI Player
class Computer < Player
  def initialize
    super 'Computer'
  end
end

# controls the gameflow
class GameController
  attr_accessor :game_over, :mode
  def initialize
    @mode = GameController.choose_mode
    @game_over = false
    @gameboard = Gameboard.new(@mode)
    welcome_message
    init_players
  end

  private

  def init_players
    print 'Player 1 name: '
    @gameboard.player1 = Player.new(gets.chomp)
    if @mode == 1
      print 'Player 2 name: '
      @gameboard.player2 = Player.new(gets.chomp)
    else
      create_computer
    end
  end

  def create_computer
    @gameboard.player2 = Computer.new
  end

  def declare_winner
    if @gameboard.turn.zero?
      puts "It's a draw"
      @gameboard.turn = 1
    else
      player1 = @gameboard.player1.name
      player2 = @gameboard.player2.name
      winner = @gameboard.turn == 1 ? player2 : player1
      puts "Game Over! #{winner} has won!"
    end
  end

  def check_board
    x_wins = /^(XXX)|.{3}XXX.{3}|XXX$|X..X..X|.X..X..X.|..X..X..X|X...X...X|..X.X.X../
    o_wins = /^(OOO)|.{3}OOO.{3}|OOO$|O..O..O|.O..O..O.|..O..O..O|O...O...O|..O.O.O../
    result = @gameboard.board.join
    @game_over = result.match?(x_wins) || result.match?(o_wins) || result.match?(/\D{9}/)
    if @game_over && !(result.match?(x_wins) || result.match?(o_wins))
      @gameboard.turn = 0
    end
  end

  public

  def self.choose_mode
    input = 0
    loop do
      puts 'Choose playing mode', '1) Human vs Human', '2) Human vs AI'
      input = gets.chomp
      break if [1, 2].include?(input.to_i)
    end
    input.to_i
  end

  def start_game
    @game_over = false
    until @game_over
      @gameboard.make_turn
      check_board
    end
    declare_winner
    new_game
  end

  def new_game
    @gameboard.board = %w[1 2 3 4 5 6 7 8 9]
    @gameboard.turn = 1
    puts 'New Game? y/n'
    answer = gets.chomp
    start_game if answer == 'y'
  end
end

def welcome_message
  puts 'Welcome to Tic Tac Toe!', 'Each cell on the board is represented by a number 1-9', '||||||| Good luck! |||||||',
       ''
end
controller = GameController.new
controller.start_game
