MULT = /mul\((\d{1,3})\,(\d{1,3})\)/

sum = 0

File.open(ARGV[0]).each do |input|
    input.scan(MULT) do |m|
        sum += m.reduce(1) {|prod, x| prod *= x.to_i}
    end
end

puts sum