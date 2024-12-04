
a = []
b = []
File.open(ARGV[0]).each do |line|
    x, y = line.split()
    a.push(x.to_i)
    b.push(y.to_i)
end

a.sort!
b.sort!

result = a.each_with_index.reduce(0) { |sum, (x, i)| sum += (x - b[i]).abs }

puts result
