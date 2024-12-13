Machine = Struct.new('Machine', :ax, :ay, :bx, :by, :x, :y) do
  COST_A = 3
  COST_B = 1
  MAX_PUSHES = 100

  def pushA(dx, dy)
    if dx % ax == 0 && dy % ay == 0
      return (dx / ax) * COST_A
    end 
  end

  def pushB(dx, dy)
    if dx % bx == 0 && dy % by == 0 && dx / bx == dy / by
      return (dx / bx)
    end
    nil
  end

  def iterate(cost, dx, dy, lowest_cost, num_pushes)
    return lowest_cost if num_pushes > MAX_PUSHES || dx.negative? || dy.negative?

    # weightA = ((dx / ax) + (dy / ay)) * COST_A
    # weightB = (dx / bx) + (dy / by)

    # added_cost = weightA > weightB ? pushB(dx, dy) : pushA(dx, dy)

    pushes = pushB(dx, dy)
    if pushes && pushes <= MAX_PUSHES
      # puts "FOUND #{i}: #{cost} + #{pushes} = #{cost + pushes * COST_B}, #{lowest_cost}"
      lowest_cost = [cost + pushes * COST_B, lowest_cost || Float::INFINITY].min
    end

    result = iterate(cost + COST_A, dx - ax, dy - ay, lowest_cost, num_pushes + 1)
    lowest_cost = [result, lowest_cost || Float::INFINITY].min if result
    lowest_cost
  end

  def play
    # walk(0, x, y, nil, 0) || 0
    result = iterate(0, x, y, nil, 0)
    # puts "SCORED: X=#{x}, Y=#{y}, #{result}"
    result || 0
  end
end

class Claw
  attr_accessor :machines

  DIGITS = /\d+/

  def self.create(input)
    claw = Claw.new
    input.each_slice(4) do |a, b, prize|
      ax, ay = a.scan(DIGITS).map(&:to_i)
      bx, by = b.scan(DIGITS).map(&:to_i)
      x, y = prize.scan(DIGITS).map(&:to_i)
      claw.machines << Machine.new(ax, ay, bx, by, x, y)
    end
    claw
  end

  def initialize
    @machines = []
  end

  def part1
    machines.reduce(0) { |sum, m| sum + m.play }
  end
end

input = IO.readlines(ARGV[0])

claw = Claw.create(input)
puts claw.part1