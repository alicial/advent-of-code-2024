def is_valid(nums, target)
    if nums.size == 1
        return nums.first == target
    end
    x = nums.pop
    
    return is_valid(nums.dup, target - x) || (target % x == 0 && is_valid(nums.dup, target / x))
end

sum = 0

File.open(ARGV[0]).each do |line|
    res = line.split(":")
    target = res[0].to_i
    nums = res[1].split(" ").map(&:to_i)

    sum += target if is_valid(nums, target)
end

puts sum
