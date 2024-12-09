input = IO.readlines(ARGV[0]).first.chomp
input.chop if input.size % 2 == 1 # get rid of any free space on the end

arr = input.split("").map(&:to_i)
i = 0
j = arr.size - 1
result = []

j_fileid = j / 2
j_size = arr[j]

while i <= j do
    # fill next file
    i_size = i == j ? j_size : arr[i]
    i_fileid = i / 2
    while i_size > 0
        result << i_fileid
        i_size -= 1
    end

    # fill free space with files from the end
    i += 1
    i_size = arr[i]
    while i_size > 0 do
        if j_size == 0
            j -= 2
            break if j < i
            j_fileid = j / 2
            j_size = arr[j]
        end 
        result << j_fileid
        i_size -= 1
        j_size -= 1
    end
    i += 1
end

# calculate checksum
puts result.each_with_index.reduce(0) { |sum, (x, i)| sum += x*i}