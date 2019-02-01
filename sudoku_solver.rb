require_relative 'sudoku'

class SudokuSolver
  attr_accessor :unsolved_stack
  def initialize(sudoku_instance)
    @board = sudoku_instance
    @grid = sudoku_instance.grid
    @solved_stack = []
    @unsolved_stack = unfixed_cells.reverse
  end

  def unfixed_cells
    @grid.flatten.select {|cell| !cell.fixed}
  end
  
  def render
    system('clear')
    @board.render
    sleep 0.1
  end
  
  def new_cell
    @unsolved_stack.last
  end

  def solve
    until @board.solved?
      if find_value(new_cell)
        render
        @solved_stack << @unsolved_stack.pop
      else
        backtrack
      end
    end
    render
    puts "solved!"
  end

  def find_value(cell)
    temp = cell.value == 0 ? 1 : cell.value + 1
    while temp < 10
      cell.value = temp
      return true if potential_solution?(cell)
      temp += 1
    end
    cell.value = 0
    return false
  end

  def potential_solution?(cell)
    r = @board.row_of(cell).reject {|c| c == cell}
    row = r.map(&:value)
    c = @board.column_of(cell).reject {|c| c == cell}
    col = c.map(&:value)
    s = @board.square_of(cell).reject {|c| c == cell}
    sq = s.map(&:value)
    [row, col, sq].all? {|set| !set.include?(cell.value)}
  end

  def backtrack
    if find_value(current_backtrack_cell)
      return
    else
      @unsolved_stack << @solved_stack.pop
      return backtrack
    end
  end

  def current_backtrack_cell
    @solved_stack.last
  end

end


SudokuSolver.new(Sudoku.new(ARGV[0])).solve
