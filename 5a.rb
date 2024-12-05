def is_entry_valid(entry, after)
    entry.each_with_index do |a, i|
        remaining = entry[i+1..-1]
        remaining.each do |b|
            if after[b] && after[b].has_key?(a)
                return false
            end
        end
        break if remaining.size == 1
    end
    return true
end

AFTER = {}
sum = 0

File.open(ARGV[0]).each do |line|
    if line.include?("|")
        a, b = line.chomp.split("|")
        AFTER[a] ||= {}
        AFTER[a][b] = true
    elsif line.include?(",")
        entry = line.chomp.split(",")     
        if is_entry_valid(entry, AFTER)
            sum += entry[entry.length / 2].to_i
        end
    end
end

puts sum