require 'colorize'
class Cell
  attr_reader :fixed
  attr_accessor :value
  def initialize(value)
    @value = value.to_i
    @fixed = @value == 0 ? false : true
  end

  def to_s
    if fixed 
      @value.to_s.colorize(:red)
    else
      @value.to_s
    end
  end

end

class Sudoku
  attr_accessor :grid

  def initialize(file)
    @grid = make_grid(file)
  end

  def make_grid(file)
    res = []
    open(file).each_line do |line|
      res << line.chomp.split(" ").map {|c| Cell.new(c)}
    end
    res
  end

  def render
    @grid.each do |row|
      puts row.map(&:to_s).join(" ")
    end
  end

  def solved?
    rows.all? {|row| row.map(&:value).sort == (1..9).to_a}
    columns.all? {|column| column.map(&:value).sort == (1..9).to_a}
    squares.all? {|square| square.map(&:value).sort == (1..9).to_a}
  end

  def rows
    @grid
  end

  def columns
    @grid.transpose
  end

  def squares
    res = Array.new(9) { Array.new }
    @grid.each_with_index do |row, row_index|
      row.each_slice(3).with_index do |slice, col_index|
        case col_index
        when 0
          if row_index < 3
            res[0].concat(slice)
          elsif row_index < 6
            res[3].concat(slice)
          else
            res[6].concat(slice)
          end
        when 1
          if row_index < 3
            res[1].concat(slice)
          elsif row_index < 6
            res[4].concat(slice)
          else
            res[7].concat(slice)
          end
        when 2
          if row_index < 3
            res[2].concat(slice)
          elsif row_index < 6
            res[5].concat(slice)
          else
            res[8].concat(slice)
          end
        end
      end
    end
    res
  end

  def row_of(cell)
    @grid.select {|row| row.include?(cell)}[0]
  end

  def column_of(cell)
    columns.select {|col| col.include?(cell)}[0]
  end

  def square_of(cell)
    squares.select {|sq| sq.include?(cell)}[0]
  end
end
