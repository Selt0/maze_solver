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
      map[y][x] == '*'
    end

    def travel_path(path)
      puts "Traveling path of #{path.inspect}..."
      copy_map = deep_dup(map)
      path.each do |coords|
        x, y  = coords
        point = copy_map[y][x]

        if point == 'X'
          puts "This path back-tracks to #{x}, #{y}."
        elsif point == '*'
          puts "This path hits a wall at #{x}, #{y}."
        else
          copy_map[y][x] = "X"
        end
      end
      
      show_path(copy_map)
    end

    def deep_dup(item)
      unless item.class == Array
        item.dup
      else
        new_arr = []
        item.each do |item|
          new_arr << deep_dup(item)
        end
        new_arr
      end
    end

    def show_path(map_path)
      map_path.each { |line| puts line.join('')}
    end
  end

  class MazeSolver

    attr_reader :maze

    def initialize(maze)
      @maze = maze
      reset_values
    end

    #find distance from point to end of maze
    def find_distance(point)
      p_x, p_y = point
      final_x, final_y = maze.find_end
      ((p_x - final_x) + (p_y - final_y)).abs
    end

    def find_manhattan_estimate(point)
      dist_to_end = find_distance(point)
      dist_traveled = find_path(point).length
      f = dist_to_end + dist_traveled
    end

    #estimates distance traveled and distance to end
    #picks point that should have minimum sum
    #does not take the diagonal moves into account
    def manhattan_heuristic(queue)
      queue.inject do |chosen_point, point|
        old_f = find_manhattan_estimate(chosen_point)
        new_f = find_manhattan_estimate(point)
        old_f > new_f ? point : chosen_point
      end
    end

    def build_branching_paths(heuristic = :manhattan_heuristic)
      reset_values
      queue = [@current]
      visited = [@current]

      until queue.empty? || @current == @maze.find_end
        @current = self.send(heuristic, queue)
        queue.delete(@current)
        visited << @current

        #find open spaces nearby
        nearby_openings = @maze.find_neighbors(@current)

        #add them to queue
        nearby_openings.each do |neighbor|
          unless visited.include?(neighbor) || queue.include?(neighbor)
            queue << neighbor
            @branching_paths[neighbor] = @current
          end
        end
      end

      @branching_paths
    end

    def find_path(goal = @maze.find_end)
      path = [goal]
      spot = goal
      until @branching_paths[spot] == nil
        path << @branching_paths[spot] 
        spot = @branching_paths[spot]
      end
      path
    end

    def solve(heuristic = :manhattan_heuristic)
      build_branching_paths(heuristic)
      path = find_path
      @maze.travel_path(path)
    end
    
    private

    def reset_values
      @branching_paths = {}
      @current = maze.find_start
    end
  end
end


#test
if __FILE__ == $PROGRAM_NAME
  filename = ARGV[0] || "maze1.txt"
  test_maze = MazeClasses::Maze.new(filename)
  puts test_maze
  puts "Start is at #{test_maze.start_idx}"
  puts "End is at #{test_maze.end_idx}"
  test_solver = MazeClasses::MazeSolver.new(test_maze)
  test_solver.solve
end
