def fix_entry(entry, after)
    new_entry = entry.dup
    max = entry.length - 1
    (0..max-1).each do |i|
        (i+1..max).each do |j|
            a = new_entry[i]
            b = new_entry[j]
            if after[b] && after[b].has_key?(a)
                new_entry.delete_at(j)
                new_entry.insert(i, b)
            end
        end
    end
    return new_entry if new_entry != entry
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
        new_entry = fix_entry(entry, AFTER)
        sum += new_entry[new_entry.length / 2].to_i if new_entry
    end
end

puts sum