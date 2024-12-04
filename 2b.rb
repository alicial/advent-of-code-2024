
def is_rest_safe(arr, is_decreasing, has_skipped)
    if (arr.size <= 1)
        return true
    end
    arr2 = arr.dup
    if !has_skipped
        # try skipping next elem
        arr2.delete_at(1)
        if is_rest_safe(arr2, is_decreasing, true)
            return true
        end
    end
    a = arr.shift
    if (is_decreasing && (arr.first < a && (a - arr.first) <= 3)) || (!is_decreasing && (arr.first > a && (arr.first - a) <= 3))
        return is_rest_safe(arr, is_decreasing, has_skipped)
    else
        return false
    end
end

def is_level_safe(arr, is_decreasing)
    arr2 = arr.dup
    # try skipping first elem
    a = arr.shift
    if is_rest_safe(arr, is_decreasing, true)
        return true
    end
    return is_rest_safe(arr2, is_decreasing, false)
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