
DIR_ONE = [
    [{x: -1, y:-1, c: "M"}, {x: 1, y:1, c: "S"}],
    [{x: -1, y:-1, c: "S"}, {x: 1, y:1, c: "M"}]
]
DIR_TWO = [
    [{x:1,y:-1, c: "M"}, {x: -1, y: 1, c: "S"}],
    [{x:1,y:-1, c: "S"}, {x: -1, y: 1, c: "M"}]
]

def is_MAS(grid, directions, x, y, max_x, max_y)
    directions.each do |direction|
        direction.each_with_index do |d, ii|
            dx = x + d[:x]
            dy = y + d[:y]
            break if dx < 0 || dx > max_x || dy < 0 || dy > max_y || grid[dy][dx] != d[:c]
            return true if ii == 1
        end
    end
    false
end


lines = IO.readlines(ARGV[0])
sum = 0
max_x = lines.first.length - 1
max_y = lines.length - 1

lines.each_with_index do |line, y|
    i = 0
    loop do
        x = line.index("A", i)
        break if x.nil?
        
        sum += 1 if is_MAS(lines, DIR_ONE, x, y, max_x, max_y) && is_MAS(lines, DIR_TWO, x, y, max_x, max_y)
        i = x + 1
    end
end

puts sum