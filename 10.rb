Position = Struct.new("Position", :x, :y, :height, :trail_ends, :unique_paths) do
  
  def is_downhill_of(p)
    height == p.height - 1
  end

  def is_trail
    !trail_ends.nil?
  end
end

class Topo
  attr_accessor :by_coords, :by_height
  DIRECTIONS = [[-1, 0], [0, -1], [1, 0], [0, 1]]
  MAX_HEIGHT = 9

  def self.create(input)
    topo = Topo.new
  
    input.each_with_index do |line, y|    
      line.chomp.chars.each_with_index do |c, x|
        topo.update_position(x, y, c.to_i)
      end
    end

    topo
  end

  def initialize
    @by_coords = {}
    @by_height = Hash[(0..MAX_HEIGHT).map{|i| [i, []]}]
  end

  def update_position(x, y, height)
    p = Position.new(x, y, height, nil, 0)    
    if height == MAX_HEIGHT
      p.trail_ends = Set[[x, y]]
      p.unique_paths = 1
    end
    @by_coords[[x, y]] = p
    @by_height[height] << p
  end

  def position_at(x, y)
    @by_coords[[x, y]]
  end

  def trails_at_height(h)
    @by_height[h].filter(&:is_trail)
  end

  def neighbors(pos)
    DIRECTIONS.map { |dx, dy| position_at(pos.x + dx, pos.y + dy) }.compact
  end

  def each_downhill_neighbor(pos)
    neighbors(pos).filter{ |n| n.is_downhill_of(pos) }.each do |n|
      yield n
    end
  end

  def each_trail_position
    MAX_HEIGHT.step(0, -1).each do |h|
      trails_at_height(h).each do |pos|
        yield pos
      end
    end
  end

  def traverse
    each_trail_position do |pos|
      each_downhill_neighbor(pos) do |n|
        n.unique_paths += pos.unique_paths
        n.trail_ends ||= Set.new
        n.trail_ends.merge(pos.trail_ends)
      end
    end
  end

  def part1
    trails_at_height(0).reduce(0) { |sum, pos| sum + pos.trail_ends.size }
  end

  def part2
    trails_at_height(0).reduce(0) { |sum, pos| sum + pos.unique_paths }
  end
end


topo = Topo.create(IO.readlines(ARGV[0]))

topo.traverse

puts topo.part1
puts topo.part2