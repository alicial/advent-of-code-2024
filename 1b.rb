
a = []
b = []
File.open(ARGV[0]).each do |line|
    x, y = line.split()
    a.push(x.to_i)
    b.push(y.to_i)
end

result = a.reduce(0) { |score, x| score += x * b.count(x) }

puts result
