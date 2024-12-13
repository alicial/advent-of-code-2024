Machine = Struct.new('Machine', :ax, :ay, :bx, :by, :x, :y) do
  COST_A = 3
  COST_B = 1
  MAX_PUSHES = 100

  def solve_equations
    det = ax * by - ay * bx
    return nil if det == 0

    n = by * x - bx * y
    m = -ay * x + ax * y

    [n / det, m / det] if n % det == 0 && m % det == 0
  end

  def solve
    n, m = solve_equations
    n && m ? n * COST_A + m * COST_B : 0
  end

  def pushA(cost, dx, dy)
    [cost + COST_A, dx - ax, dy - ay]
  end

  def pushB(cost, dx, dy)
    if dx % bx == 0 && dy % by == 0 && dx / bx == dy / by
      b_pushes = (dx/bx)
      return cost + b_pushes * COST_B
    end
    nil
  end

  def solve_original
    cost = 0
    dx = x
    dy = y
    lowest_cost = nil
    a_pushes = 0
    until (lowest_cost && cost >= lowest_cost) || dx.negative? || dy.negative?
      total_cost = pushB(cost, dx, dy)
      lowest_cost = [total_cost, lowest_cost || Float::INFINITY].min if total_cost
      cost, dx, dy = pushA(cost, dx, dy)
      a_pushes += 1
    end
    lowest_cost || 0
  end
end

class Claw
  attr_accessor :machines

  DIGITS = /\d+/
  BIGNUM = 10_000_000_000_000

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
    machines.reduce(0) { |sum, m| sum + m.solve }
  end

  def part2
    machines.reduce(0) do |sum, m|
      m.x += BIGNUM
      m.y += BIGNUM
      sum + m.solve
    end
  end
end

input = IO.readlines(ARGV[0])

claw = Claw.create(input)
puts claw.part1
puts claw.part2