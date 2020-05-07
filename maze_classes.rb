module MazeClasses

  class Maze
    DELTAS = [[1, 0], [0, 1], [-1, 0], [0, -1]]

    attr_reader :start_idx, :end_idx, :map, :title
    def initialize(filename)
      @map = load_map(filename)
      @title = parse_title(filename)
      @start_idx = find_start
      @end_idx = find_end
    end

    def load_map(filename)
      maze = []
      File.open(filename).each_line do |line|
        chars = line.split(//)
        maze << chars
      end
      maze
    end

    def parse_title(filename)
      filename.match(/(.+)\.txt/)[1]
    end

    def find_start
      find_char('S')
    end

    def find_end
      find_char('E')
    end

    def find_char(char)
      map.each_with_index do |line, y|
        return [line.index(char), y] if line.index(char)
      end
    end

    def to_s
      string = "MAZE: #{title}\n"
      map.each { |line| string << line.join('') }
      string
    end

    def find_neighbors(point)
      p_x, p_y = point
      neighbors = []

      DELTAS.each do |d_x, d_y|
        neighbor = [(d_x + p_x), (d_y + p_y)]
        if in_maze?(neighbor) && !(is_wall?(neighbor))
          neighbors << neighbor
        end
      end
      neighbors
    end

    def in_maze?(point)
      x, y = point
      not_negative = (x >= 0) && (y >= 0)
      within_bounds = (x <= map[0].length) && (y <= map.length)
      not_negative && within_bounds
    end

    def is_wall?(point)
      x, y = point
      map[x][y] == '*'
    end
  end

  class MazeSolver

    def initialize
    end
  end
end