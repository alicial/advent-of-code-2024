require 'benchmark'

MyFile = Data.define(:id, :index, :size)

input = IO.readlines(ARGV[0]).first.chomp

result = []
fi = 0
files = [] #create an index of files so they're easier to iterate through

input.split("").map(&:to_i).each_with_index do |size, i|
    f_id = i % 2 == 0 ? i/2 : nil
    result += [f_id] * size
    files << MyFile.new(f_id, fi, size) if !f_id.nil?
    fi += size
end

def find_space(arr, file)
    i = arr.index(&:nil?)
    while i < file.index do
        available = arr[i..-1].index{|x| !x.nil?}
        break if available.nil?

        if available >= file.size
            (0..file.size-1).each do |j|
                arr[i+j] = file.id # write file to new location
                arr[file.index + j] = nil # null out previous location
            end
            return true
        end

        next_space = arr[i+available..-1].index(&:nil?)
        break if next_space.nil?
        i += available + next_space
    end
    false
end

puts Benchmark.measure {

(files.size-1).step(0, -1) { |i| find_space(result, files[i]) }

# calculate checksum
puts result.each_with_index.reduce(0) { |sum, (f_id, i)| sum + (f_id ? f_id * i : 0) }

}