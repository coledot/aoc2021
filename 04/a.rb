#! /usr/bin/env ruby

class Board
  def initialize board
    # XXX board is assumed to be always 5x5
    @board = board
    # HACK deep copy
    @orig_board = Marshal.load(Marshal.dump(@board))
  end

  def fill_value! val
    @board = @board.map { |row| row.map { |v| v == val ? v+100 : v } }
  end

  def has_bingo?
    @board.each { |row| return true if vals_are_bingo? row }
    @board.transpose.each { |col| return true if vals_are_bingo? col }
    #return true if vals_are_bingo?((0...5).collect { |idx| @board[idx][idx] })
    #return true if vals_are_bingo?((0...5).collect { |idx| @board[idx][4-idx] })
    return false
  end

  def sum_of_unmarked
    @board.map{ |row| row.select{ |v| v < 100 }.sum }.sum
  end

  def to_s
    @board.to_s
  end

  def orig
    @orig_board.to_s
  end

  private

  def vals_are_bingo? vals
    return vals.select{|v| v >= 100}.count == 5
  end
end

raw_input = File.open('./input', 'r').readlines
drawn_numbers = raw_input[0].split(',').map(&:to_i)
raw_input.delete_at(0)

boards = []
while raw_input.length > 0 do
  raw_board = raw_input[1...6].map{|board| board.strip}
  board = Board.new(raw_board.map {|row| row.split(' ').map(&:to_i)})
  puts board
  boards << board
  6.times { raw_input.delete_at(0) }
end

winning_board = nil
last_draw = drawn_numbers.first
drawn_numbers.each do |num|
  last_draw = num
  puts "draw: #{num}"
  boards.each do |board|
    board.fill_value! num
    if board.has_bingo?
      puts "WINNER"
      winning_board = board
      break
    end
    break unless winning_board.nil?
    puts board
  end
  break unless winning_board.nil?
end
puts "Winner found: #{winning_board}"

puts winning_board.sum_of_unmarked * last_draw

