

pos = nil
file = File.open(ARGV[0])
MAZE = {}
max_x = nil
max_y = nil

file.each_with_index do |line, row|
    col = 0
    loop do
        col = line.index("#", col)
        break if col.nil?
        MAZE[[col,row]] = true
        col += 1
    end
    if start_x = line.index("^")
        pos = [start_x, row]
    end
    max_x = line.size if max_x.nil?
    max_y = row
end

puts "STARTING POSITION NOT FOUND" if pos.nil?

DIRECTIONS = [[0, -1], [1, 0], [0, 1], [-1, 0]]
dir = 0
walked = {}

while pos[0] >= 0 && pos[0] <= max_x && pos[1] >= 0 && pos[1] <= max_y        
    next_pos = [pos[0]+DIRECTIONS[dir][0], pos[1]+DIRECTIONS[dir][1]]
    if MAZE[next_pos]
        dir = (dir + 1) % 4
    else
        walked[pos] = true
        pos = next_pos
    end
end

puts walked.count