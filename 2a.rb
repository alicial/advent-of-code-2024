def is_level_safe(arr, is_decreasing)
    if (arr.size == 1)
        return true
    end
    a = arr.shift
    if (is_decreasing && (arr.first < a && (a - arr.first) <= 3)) || (!is_decreasing && (arr.first > a && (arr.first - a) <= 3))
        return is_level_safe(arr, is_decreasing)
    else
        return false
    end
end

safe = 0

File.open(ARGV[0]).each_with_index do |line, i|
    level = line.split.map  { |x| x.to_i }
    level2 = level.dup
    if is_level_safe(level, true) || is_level_safe(level2, false)
        safe += 1
    end
end

puts "safe: #{safe}"