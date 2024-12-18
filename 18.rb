Node = Struct.new('Node', :x, :y, :corrupted, :score)

class RamRun
  attr_accessor :grid, :corruptions, :end_node

  DIRECTIONS = [[0, -1], [1, 0], [0, 1], [-1, 0]].freeze

  def self.create(input, grid_size)
    ramrun = RamRun.new(grid_size)
    ramrun.corruptions = input.map do |line|
      line.split(',').map(&:to_i)
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

  def reset
    @grid.each_value do |node|
      node.score = Float::INFINITY unless node.corrupted
    end
  end

  def neighbors(node)
    DIRECTIONS.map do |(dx, dy)|
      neighbor = grid[[node.x + dx, node.y + dy]]
      if neighbor && !neighbor.corrupted && neighbor.score > node.score + 1
        neighbor.score = node.score + 1
        neighbor
      end
    end.compact
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

  def corrupt(num)
    corruptions.each_with_index do |coord, i|
      break if i == num

      grid[coord].corrupted = true
    end
  end

  def part1(num_corruptions)
    corrupt(num_corruptions)
    traverse
  end

  def part2(num_corruptions)
    corrupt(num_corruptions)
    while num_corruptions < corruptions.size
      coord = corruptions[num_corruptions]
      grid[coord].corrupted = true
      reset
      return coord.join(',') if traverse == Float::INFINITY

      num_corruptions += 1
    end
  end
end

LINES_TO_READ = 1024
GRID_SIZE = 70

ramrun = RamRun.create(IO.readlines(ARGV[0]), GRID_SIZE)
puts ramrun.part1(LINES_TO_READ)
puts ramrun.part2(LINES_TO_READ)
