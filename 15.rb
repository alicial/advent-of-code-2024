require 'pry'
require 'rutui'

Item = Struct.new('Item', :type, :x, :y) do
  def wall?
    type == Warehouse::WALL
  end

  def box?
    type == Warehouse::BOX
  end

  def ui
    @ui ||= RuTui::Text.new({ x: x, y: y, text: type })
  end

  def draw
    ui.set_position(x, y)
  end

  def gps
    box? ? 100 * y + x : 0
  end
end

class Warehouse
  attr_accessor :grid, :instructions, :robot

  MOVES = { '<': [-1, 0], '^': [0, -1], '>': [1, 0], 'v': [0, 1] }.freeze
  WALL = '#'.freeze
  BOX = 'O'.freeze
  ROBOT = '@'.freeze

  def self.create(input)
    warehouse = Warehouse.new

    grid_input, instructions_input = input.slice_after("\n").to_a
    warehouse.create_grid(grid_input)
    warehouse.instructions = instructions_input.map(&:chomp).join.chars.map(&:to_sym)
    warehouse
  end

  def initialize
    @grid = {}
    @instructions = []
    @robot = nil
  end

  def create_grid(input)
    input.each_with_index do |line, y|
      break unless line[0] == WALL

      line.chars.each_with_index do |c, x|
        grid[[x, y]] = Item.new(c, x, y) if [WALL, BOX, ROBOT].include?(c)
        @robot = grid[[x, y]] if c == ROBOT
      end
    end
  end

  def move_recursive?(item, direction)
    if item.nil?
      return true
    elsif item.wall?
      return false
    end

    x = item.x + MOVES[direction][0]
    y = item.y + MOVES[direction][1]
    move = move?(grid[[x, y]], direction)
    if move
      grid[[x, y]] = item
      item.x = x
      item.y = y
    end
    move
  end

  def move?(items, direction)
    dx, dy = MOVES[direction]
    loop do
      item = items.last
      x = item.x + dx
      y = item.y + dy
      next_item = grid[[x, y]]

      if next_item.nil?
        until items.empty?
          item = items.pop
          px = item.x
          py = item.y
          grid[[x, y]] = item
          item.x = x
          item.y = y
          x = px
          y = py
        end
        return true
      elsif next_item.wall?
        return false
      else
        items << next_item
      end
    end
  end

  def move_robot(direction)
    rx = robot.x
    ry = robot.y
    move = move?([robot], direction)

    grid.delete([rx, ry]) if move
    move
  end

  def draw
    screen = RuTui::Screen.new
    grid.each_value { |item| screen.add(item.ui) }
    i = 0
    RuTui::ScreenManager.loop(autodraw: true) do |key|
      break if key == 'q' || i == instructions.size

      direction = instructions[i]
      if move_robot(direction)
        screen.add RuTui::Text.new({ x: 0, y: 0, text: direction.to_s })
        grid.each_value(&:draw)
      end
      i += 1
    end
  end

  def part1
    instructions.each do |direction|
      move_robot(direction)
    end
    grid.values.reduce(0) { |sum, item| sum + (item&.gps || 0) }
  end
end

warehouse = Warehouse.create(IO.readlines(ARGV[0]))
puts warehouse.part1
# warehouse.draw
