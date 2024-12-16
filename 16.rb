require 'pry'
require 'rutui'

Node = Struct.new('Node', :x, :y, :score) do
  def is?(node)
    x == node.x && y == node.y
  end

  def ui_text
    score.nil? ? '.' : 'X'
  end

  def ui
    @ui ||= RuTui::Text.new({ x: x, y: y, text: ui_text })
  end

  def draw
    ui.set_text(ui_text)
  end
end

class Maze
  attr_accessor :grid, :start_node, :end_node

  DIRECTIONS = [[0, -1], [1, 0], [0, 1], [-1, 0]].freeze

  def self.create(input)
    maze = Maze.new
    maze.create_grid(input)
    maze
  end

  def initialize
    @grid = {}
  end

  def create_grid(input)
    input.each_with_index do |line, y|
      line.chars.each_with_index do |c, x|
        grid[[x, y]] = Node.new(x, y) if ['.', 'E', 'S'].include?(c)
        if c == 'S'
          @start_node = grid[[x, y]]
        elsif c == 'E'
          @end_node = grid[[x, y]]
        end
      end
    end
  end

  def neighbors(node, dir, score)
    neighbors = DIRECTIONS.map.with_index do |(dx, dy), di|
      next if (di - 2) % 4 == dir # came from this direction

      neighbor = grid[[node.x + dx, node.y + dy]]
      next unless neighbor

      neighbor_score = score + 1
      neighbor_score += 1000 if di != dir
      if neighbor.score.nil? || neighbor.score > neighbor_score
        neighbor.score = neighbor_score
        [neighbor, di, neighbor_score]
      end
    end
    neighbors.compact
  end

  def traverse(start_direction)
    start_node.score = 0
    queue = [[start_node, start_direction, 0]]
    lowest_score = Float::INFINITY
    until queue.empty?
      new_queue = []
      until queue.empty?
        node, dir, score = queue.shift
        if node.is?(end_node)
          lowest_score = [lowest_score, score].min
          next
        end

        new_queue += neighbors(node, dir, score)
      end
      queue = new_queue
    end

    lowest_score
  end

  def draw(start_direction)
    start_node.score = 0
    queue = [[start_node, start_direction, 0]]
    screen = RuTui::Screen.new
    score_text = RuTui::Text.new({ x: 0, y: 0, text: '' })
    screen.add score_text
    grid.each_value { |node| screen.add(node.ui) }
    lowest_score = Float::INFINITY
    i = 0
    RuTui::ScreenManager.loop(autodraw: true) do |key|
      break if key == 'q' || queue.empty?

      queue.each do |(n, _d)|
        n.ui.set_text('*')
      end
      new_queue = []
      until queue.empty?
        node, dir, score = queue.shift
        if node.is?(end_node)
          lowest_score = [lowest_score, score].min
          score_text.set_text(lowest_score.to_s)
          next
        end
        new_queue += neighbors(node, dir, score)
      end
      new_queue.each do |(n, _d)|
        n.ui.set_text('X')
      end
      queue = new_queue
      i += 1
    end
    lowest_score
  end

  def part1
    traverse(1)
    # draw(1)
  end
end

maze = Maze.create(IO.readlines(ARGV[0]))
puts maze.part1
