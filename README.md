# Maze Solver

Tihs program will find a route between two points in a maze.

I used the _Manhattan method_, where you calculate the total number of squares moved horizontally and vertically to reach the target square from the current square, ignoring diagonal movement, and ignoring any obstacles that may be in the way

I was able to create it with help from this [guide](http://archive.gamedev.net/archive/reference/articles/article2003.html)

---

The program reads a maze from a file and prints out the empty maze, along with the starting and ending positions. It then displays the path taken followed by a finished maze

```ruby
[mazesolver_project (master)]$ ruby maze_classes.rb
MAZE: maze1
****************
*         *   E*
*    *    *  ***
*    *    *    *
*    *    *    *
*    *    *    *
*S   *         *
****************
Start is at [1, 6]
End is at [14, 1]
Traveling path of [[14, 1], [13, 1], [12, 1], [12, 2], [12, 3], [12, 4], [11, 4], [11, 5], [11, 6], [10, 6], [9, 6], [9, 5], [9, 4], [9, 3], [9, 2], [9, 1], [8, 1], [7, 1], [6, 1], [5, 1], [4, 1], [4, 2], [4, 3], [4, 4], [4, 5], [4, 6], [3, 6], [2, 6], [1, 6]]...
****************
*   XXXXXX* XXX*
*   X*   X* X***
*   X*   X* X  *
*   X*   X*XX  *
*   X*   X*X   *
*XXXX*   XXX   *
****************
```

---

I added a default load in when you run ruby with the name of the file

```ruby
if __FILE__ == $PROGRAM_NAME
  filename = ARGV[0] || "maze1.txt"
  test_maze = MazeClasses::Maze.new(filename)
  puts test_maze
  puts "Start is at #{test_maze.start_idx}"
  puts "End is at #{test_maze.end_idx}"
  test_solver = MazeClasses::MazeSolver.new(test_maze)
  test_solver.solve
end
```
