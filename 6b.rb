pos = nil
file = File.open(ARGV[0])
DEBUG = ARGV.include?("--debug")
MAZE = {}
DIRECTIONS = [[0, -1], [1, 0], [0, 1], [-1, 0]]
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

# check if there's a loop if we put an obstacle at obstacle_pos
def check_loop(obstacle_pos, start_pos, dir, walked, max_x, max_y)
    pos = start_pos.dup
    visited = {}

    while pos[0] > 0 && pos[0] < max_x && pos[1] > 0 && pos[1] < max_y   
        visited[pos] ||= walked[pos].dup || []
        visited[pos] << dir if !visited[pos].include?(dir)

        next_pos = [pos[0]+DIRECTIONS[dir][0], pos[1]+DIRECTIONS[dir][1]]
        next_dir = (dir + 1) % 4                

        if MAZE[next_pos] || next_pos == obstacle_pos
            dir = next_dir
        else
            if visited[next_pos] && visited[next_pos].include?(dir)
                puts "LOOP DETECTED with obstacle at: #{obstacle_pos}" if DEBUG
                return true
            end
            pos = next_pos
        end

    end
    false
end

dir = 0
walked = {}
obstacles = 0
checked = {}

while pos[0] > 0 && pos[0] < max_x && pos[1] > 0 && pos[1] < max_y
    walked[pos] ||= []
    walked[pos] << dir if !walked[pos].include?(dir)

    next_pos = [pos[0]+DIRECTIONS[dir][0], pos[1]+DIRECTIONS[dir][1]]
    next_dir = (dir + 1) % 4

    if MAZE[next_pos]
        dir = next_dir
    else
        if !checked[next_pos]
            checked[next_pos] = true
            if check_loop(next_pos, pos, dir, walked, max_x, max_y)
                obstacles += 1
            end           
        end
        pos = next_pos
    end
end

puts obstacles
