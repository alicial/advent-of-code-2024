require 'rutui'

Robot = Struct.new('Robot', :x, :y, :vx, :vy) do
  def next_tile(val, max)
    return val - max if val >= max
    return max + val if val < 0

    val
  end

  def move
    self.x = next_tile(x + vx, Restroom::WIDTH)
    self.y = next_tile(y + vy, Restroom::HEIGHT)
    x.zero? ? 1 : 0
  end

  def draw
    ui.set_position(x, y)
  end

  def ui
    @ui_text ||= RuTui::Text.new({ x: x, y: y, text: 'O' })
  end

  def quadrant
    if x < Restroom::HALF_WIDTH
      return 0 if y < Restroom::HALF_HEIGHT

      1 if y > Restroom::HALF_HEIGHT
    elsif x > Restroom::HALF_WIDTH
      return 2 if y < Restroom::HALF_HEIGHT

      3 if y > Restroom::HALF_HEIGHT
    end
  end
end

class Restroom
  attr_accessor :input, :robots, :iteration

  DIGITS = /-?\d+/
  WIDTH = 101
  HEIGHT = 103
  HALF_WIDTH = WIDTH / 2
  HALF_HEIGHT = HEIGHT / 2

  def self.create(input)
    restroom = Restroom.new
    restroom.robots = input.map do |line|
      x, y, vx, vy = line.scan(DIGITS).map(&:to_i)
      Robot.new(x, y, vx, vy)
    end
    restroom
  end

  def initialize
    @robots = []
    @iteration = 0
  end

  def quadrant_counts
    by_quadrant = robots.group_by(&:quadrant)
    by_quadrant.delete(nil)
    by_quadrant.values.map(&:count)
  end

  def move(num = 1)
    num.times { robots.each(&:move) }
  end

  def part1
    move(100)
    quadrant_counts.reduce(&:*)
  end

  def draw_screen(iteration = 0)
    iteration.times { robots.each(&:move) }

    screen = RuTui::Screen.new
    robots.each { |r| screen.add(r.ui) }
    RuTui::ScreenManager.loop(autodraw: true) do |key|
      break if key == 'q'

      until robots.map(&:x).tally.values.max >= 30 && robots.map(&:y).tally.values.max >= 30
        move
        iteration += 1
      end
      screen.add RuTui::Text.new({ x: 0, y: 0, text: iteration.to_s })
      robots.each(&:draw)
      move
      iteration += 1
    end
  end

  def part2
    draw_screen(0)
  end
end

input = IO.readlines(ARGV[0])

Restroom.create(input).part1
Restroom.create(input).part2
