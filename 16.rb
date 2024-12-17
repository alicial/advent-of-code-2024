require 'rutui'

Node = Struct.new('Node', :x, :y, :score) do
  def is?(node)
    x == node.x && y == node.y
  end

  def ui
    @ui ||= RuTui::Text.new({ x: x, y: y, text: '.' })
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
        grid[[x, y]] = Node.new(x, y, nil) if ['.', 'E', 'S'].include?(c)
        if c == 'S'
          @start_node = grid[[x, y]]
        elsif c == 'E'
          @end_node = grid[[x, y]]
        end
      end
    end
  end

  def neighbors(node, dir, score, path)
    neighbors = DIRECTIONS.map.with_index do |(dx, dy), di|
      next if (di - 2) % 4 == dir # came from this direction

      neighbor = grid[[node.x + dx, node.y + dy]]
      next unless neighbor

      neighbor_score = score + 1
      neighbor_score += 1000 if di != dir
      if neighbor.score.nil? || neighbor_score <= neighbor.score + 1000
        neighbor.score = neighbor_score
        [[neighbor, di, neighbor_score], Set[neighbor].merge(path)]
      end
    end
    neighbors.compact
  end

  def process(queue, lowest_score, nodes_on_path)
    new_queue = {}
    queue.each do |(node, dir, score), path|
      next if score > lowest_score

      if node.is?(end_node)
        if score < lowest_score
          nodes_on_path = path
          lowest_score = score
        end
        next
      end

      neighbors(node, dir, score, path).each do |k, p|
        if new_queue.key?(k)
          new_queue[k].merge(p)
        else
          new_queue[k] = p
        end
      end
    end
    [new_queue, lowest_score, nodes_on_path]
  end

  def traverse(start_direction)
    start_node.score = 0
    queue = { [start_node, start_direction, 0] => Set[start_node] }
    lowest_score = Float::INFINITY
    nodes_on_path = []
    queue, lowest_score, nodes_on_path = process(queue, lowest_score, nodes_on_path) until queue.empty?
    [lowest_score, nodes_on_path.size]
  end

  def visualize(start_direction)
    screen = RuTui::Screen.new
    score_text = RuTui::Text.new({ x: 0, y: 0, text: '' })
    screen.add score_text
    grid.each_value { |node| screen.add(node.ui) }

    start_node.score = 0
    queue = { [start_node, start_direction, 0] => Set[start_node] }
    lowest_score = Float::INFINITY
    nodes_on_path = []

    RuTui::ScreenManager.loop(autodraw: true) do |key|
      break if key == 'q' || queue.empty?

      queue.each_key { |(n, _)| n.ui.set_text('X') }
      queue, lowest_score, nodes_on_path = process(queue, lowest_score, nodes_on_path)
      queue.each_key { |(n, _)| n.ui.set_text('O') }
    end
    [lowest_score, nodes_on_path.size]
  end
end

maze = Maze.create(IO.readlines(ARGV[0]))
part1, part2 = maze.traverse(1)
puts part1
puts part2

# puts maze.visualize(1)
