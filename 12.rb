Node = Struct.new('Node', :x, :y, :id) do
  def same_region?(*nodes)
    nodes.all? { |n| n && n.id == id }
  end
end

class Garden
  attr_accessor :grid

  DIRECTIONS = [[0, -1], [1, 0], [0, 1], [-1, 0]].freeze
  DIAGONALS = [[1, -1], [1, 1], [-1, 1], [-1, -1]].freeze

  def self.create(input)
    garden = Garden.new
    input.each_with_index do |line, y|
      line.chomp.chars.each_with_index do |c, x|
        garden.grid[[x, y]] = Node.new(x, y, c)
      end
    end
    garden
  end

  def initialize
    @grid = {}
  end

  def neighbors(node)
    DIRECTIONS.map { |dx, dy| grid[[node.x + dx, node.y + dy]] }
  end

  def get_region(node, region)
    return if region.add?(node).nil?

    neighbors(node).each { |n| get_region(n, region) if node.same_region?(n) }
  end

  def each_region(remaining)
    until remaining.empty?
      region = Set.new
      get_region(remaining.first, region)
      yield region
      remaining.subtract(region)
    end
  end

  def count_edges(node)
    neighbors(node).filter { |n| !node.same_region?(n) }.size
  end

  def diagonal(node, dir)
    diagonal = DIAGONALS[dir]
    grid[[node.x + diagonal[0], node.y + diagonal[1]]]
  end

  def outer_corners(node, neighbor_pairs)
    neighbor_pairs.filter { |a, b| !node.same_region?(a) && !node.same_region?(b) }
  end

  def inner_corners(node, neighbor_pairs)
    neighbor_pairs.with_index.filter do |(a, b), dir|
      node.same_region?(a, b) && !node.same_region?(diagonal(node, dir))
    end
  end

  def count_corners(node)
    neighbors = neighbors(node)
    neighbors << neighbors.first
    pairs = neighbors.each_cons(2)

    outer_corners(node, pairs).size + inner_corners(node, pairs).size
  end

  def part1
    sum = 0
    each_region(Set.new(grid.values)) do |region|
      sum += region.size * region.reduce(0) { |acc, node| acc + count_edges(node) }
    end
    sum
  end

  def part2
    sum = 0
    each_region(Set.new(grid.values)) do |region|
      sum += region.size * region.reduce(0) { |acc, node| acc + count_corners(node) }
    end
    sum
  end
end

input = IO.readlines(ARGV[0])

garden = Garden.create(input)
puts garden.part1
puts garden.part2