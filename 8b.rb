lines = IO.readlines(ARGV[0])
MAX_X = lines.first.chomp.size - 1
MAX_Y = lines.size - 1
antennas = {}
nodes = {}

lines.each_with_index do |line, y|
    line.chars.each_with_index do |char, x|
        if /\w/.match?(char)
            antennas[char] ||= []
            antennas[char] << [x, y]
        end
    end
end

def in_bounds(x, y)
    x >= 0 && x <= MAX_X && y >= 0 && y <= MAX_Y
end

antennas.each do |char, coordinates|
    coordinates.combination(2).each do |a, b|
        dx = b[0] - a[0]
        dy = b[1] - a[1]
        x1 = a[0]
        y1 = a[1]
        loop do
            nodes[[x1, y1]] = true 
            x1 = x1 - dx
            y1 = y1 - dy
            break if !in_bounds(x1, y1)
        end

        x2 = b[0]
        y2 = b[1]
        loop do
            nodes[[x2, y2]] = true 
            x2 = x2 + dx
            y2 = y2 + dy
            break if !in_bounds(x2, y2)
        end
    end
end

puts nodes.count