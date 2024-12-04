MULT = /mul\((\d{1,3})\,(\d{1,3})\)/

input = IO.readlines(ARGV[0]).join(" ")

sum = 0
start_index = 0

while !start_index.nil? do
    stop_index = input.index("don't()", start_index) || -1
    input[start_index..stop_index].scan(MULT) do |m|
        sum += m.reduce(1) {|prod, x| prod *= x.to_i}
    end
    start_index = input.index("do()", stop_index)
end

puts sum