
SEARCH_SPACE = [
    [{x: -1, y: 0, c: "M"}, {x: -2, y: 0, c: "A"}, {x: -3, y: 0, c: "S"}],
    [{x: -1, y: -1, c: "M"}, {x: -2, y: -2, c: "A"}, {x: -3, y: -3, c: "S"}],
    [{x: 0, y: -1, c: "M"}, {x: 0, y: -2, c: "A"}, {x: 0, y: -3, c: "S"}],
    [{x: 1, y: -1, c: "M"}, {x: 2, y: -2, c: "A"}, {x: 3, y: -3, c: "S"}],
    [{x: 1, y: 0, c: "M"}, {x: 2, y: 0, c: "A"}, {x: 3, y: 0, c: "S"}],
    [{x: 1, y: 1, c: "M"}, {x: 2, y: 2, c: "A"}, {x: 3, y: 3, c: "S"}],
    [{x: 0, y: 1, c: "M"}, {x: 0, y: 2, c: "A"}, {x: 0, y: 3, c: "S"}],
    [{x: -1, y: 1, c: "M"}, {x: -2, y: 2, c: "A"}, {x: -3, y: 3, c: "S"}]
]


lines = IO.readlines(ARGV[0])
sum = 0
max_x = lines.first.length - 1
max_y = lines.length - 1

lines.each_with_index do |line, y|
    i = 0
    loop do
        x = line.index("X", i)
        break if x.nil?
        
        SEARCH_SPACE.each do |direction|
            direction.each do |d|
                dx = x + d[:x]
                dy = y + d[:y]
                break if dx < 0 || dx > max_x || dy < 0 || dy > max_y || lines[dy][dx] != d[:c]
                sum += 1 if d[:c] == "S"
            end
        end
        i = x + 1
    end
end

puts sum