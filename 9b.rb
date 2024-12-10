require 'benchmark'

MyFile = Data.define(:id, :index, :size)

class MyDisk
    attr_accessor :blocks, :files

    def self.create(str)
        disk = MyDisk.new
        fi = 0
        str.chars.map(&:to_i).each_with_index do |size, i|
            f_id = i % 2 == 0 ? i/2 : nil
            disk.blocks += [f_id] * size
            disk.files << MyFile.new(f_id, fi, size) if !f_id.nil?
            fi += size
        end
        disk
    end

    def initialize
        @blocks = []
        @files = []
    end

    def defrag
        files.reverse.each do |file| 
            index = find_space(file)
            move_file_to_index(file, index) if !index.nil?
        end
    end

    def move_file_to_index(file, index)
        (0..file.size-1).each do |i|
            blocks[index + i] = file.id # write file to new location
            blocks[file.index + i] = nil # null out previous location
        end
    end

    def find_space_size(index)
        size = 0
        while blocks[index].nil? && index < blocks.size do
            size += 1
            index += 1
        end
        size
    end

    def find_next_space(index, end_index)
        i = blocks[index..end_index].index(&:nil?)
        
        if i.nil?
            [nil, 0]
        else
            [index + i, find_space_size(index + i)]
        end
    end

    def find_space(file)
        i = 0
        loop do
            next_space, space_size = find_next_space(i, file.index)
            break if next_space.nil?
            
            return next_space if space_size >= file.size
            i = next_space + space_size
        end
        nil
    end

    def checksum
        blocks.each_with_index.reduce(0) { |sum, (f_id, i)| sum + (f_id ? f_id * i : 0) }
    end
end

input = IO.readlines(ARGV[0]).first.chomp

disk = MyDisk.create(input)

puts Benchmark.measure {

disk.defrag
puts disk.checksum

}