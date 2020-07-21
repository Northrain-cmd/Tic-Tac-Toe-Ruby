# frozen_string_literal: true

# creates gameboards
class Gameboard
  attr_accessor :player1, :player2
  attr_accessor :turn, :board
  def initialize
    @turn = 1
    @board = %w[1 2 3 4 5 6 7 8 9]
  end

  private

  def show_board
    puts '',
         "#{@board[0]}  #{@board[1]}  #{@board[2]}",
         '',
         "#{@board[3]}  #{@board[4]}  #{@board[5]}",
         '',
         "#{@board[6]}  #{@board[7]}  #{@board[8]}",
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

  public

  def make_turn
    cell = input
    while place_taken?(cell)
      puts 'Spot taken, try another one'
      cell = input
    end
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

# controls the gameflow
class GameController
  attr_accessor :game_over
  def initialize
    @game_over = false
    @gameboard = Gameboard.new
    print 'Player 1 name: '
    name1 = gets.chomp
    print 'Player 2 name: '
    name2 = gets.chomp
    @gameboard.player1 = Player.new(name1)
    @gameboard.player2 = Player.new(name2)
  end

  private

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
    @gameboard.turn = 0 if result.match?(/\D{9}/)
  end

  public

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
    puts 'New Game? y/n'
    answer = gets.chomp
    start_game if answer == 'y'
  end
end

controller = GameController.new
controller.start_game
