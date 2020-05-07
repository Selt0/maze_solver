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
  end

  class MazeSolver

    def initialize
    end
  end
end