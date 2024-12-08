require 'benchmark'

def is_valid(nums, target)
    if nums.size == 1
        return nums.first == target
    end    
    
    a = nums.shift
    b = nums.shift

    is_valid(nums.dup.unshift((a.to_s + b.to_s).to_i), target) || is_valid(nums.dup.unshift(a + b), target) || is_valid(nums.dup.unshift(a * b), target)
end

puts Benchmark.measure {

sum = 0

File.open(ARGV[0]).each do |line|
    res = line.split(":")
    target = res[0].to_i
    nums = res[1].split(" ").map(&:to_i)

    sum += target if is_valid(nums, target)
end

puts sum

}