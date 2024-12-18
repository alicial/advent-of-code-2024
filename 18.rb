require 'rutui'

Node = Struct.new('Node', :x, :y, :corrupted, :score) do
  def is?(node)
    x == node.x && y == node.y
  end

  def ui_text
    corrupted ? '#' : '.'
  end

  def ui
    @ui ||= RuTui::Text.new({ x: x, y: y, text: ui_text })
  end
end

class RamRun
  attr_accessor :grid, :end_node

  DIRECTIONS = [[0, -1], [1, 0], [0, 1], [-1, 0]].freeze

  def self.create(input, lines_to_read, grid_size)
    ramrun = RamRun.new(grid_size)
    input.each_with_index do |line, i|
      x, y = line.split(',').map(&:to_i)
      ramrun.grid[[x, y]].corrupted = true
      break if i == lines_to_read - 1
    end
    ramrun
  end

  def initialize(size)
    @grid = {}
    (size + 1).times do |y|
      (size + 1).times do |x|
        @grid[[x, y]] = Node.new(x, y, false, Float::INFINITY)
      end
    end
    @end_node = @grid[[size, size]]
  end

  def neighbors(node)
    neighbors = DIRECTIONS.map do |(dx, dy)|
      neighbor = grid[[node.x + dx, node.y + dy]]
      next if neighbor.nil? || neighbor.corrupted

      if neighbor.score > node.score + 1
        neighbor.score = node.score + 1
        neighbor
      end
    end
    neighbors.compact
  end

  def process(queue, shortest)
    new_queue = Set.new
    queue.each do |node|
      if node == end_node
        shortest = node.score if node.score < shortest
        next
      end

      new_queue.merge(neighbors(node))
    end
    [new_queue, shortest]
  end

  def traverse
    start_node = grid[[0, 0]]
    start_node.score = 0
    queue = Set[start_node]
    shortest = Float::INFINITY
    queue, shortest = process(queue, shortest) until queue.empty?
    shortest
  end

  def visualize
    screen = RuTui::Screen.new
    score_text = RuTui::Text.new({ x: 0, y: 0, text: '' })
    screen.add score_text
    grid.each_value { |node| screen.add(node.ui) }

    start_node = grid[[0, 0]]
    start_node.score = 0
    queue = Set[start_node]
    shortest = Float::INFINITY

    RuTui::ScreenManager.loop(autodraw: true) do |key|
      break if key == 'q' || queue.empty?

      queue.each { |(n)| n.ui.set_text('X') }
      queue, shortest = process(queue, shortest) until queue.empty?
      queue.each { |(n)| n.ui.set_text('O') }
    end
    shortest
  end

  def part1
    traverse
  end
end

LINES_TO_READ = 1024
GRID_SIZE = 70
puts RamRun.create(IO.readlines(ARGV[0]), LINES_TO_READ, GRID_SIZE).part1
