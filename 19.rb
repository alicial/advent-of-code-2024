Node = Struct.new('Node', :char, :next, :terminal)

class Onsen
  attr_accessor :head_nodes, :targets

  def self.create(input)
    onsen = Onsen.new
    towels = input.shift.chomp.split(', ').map(&:chars)
    onsen.create_towel_tree(towels)
    input.shift # blank line
    onsen.targets = input.map(&:chomp)
    onsen
  end

  def create_towel_tree(towels)
    @head_nodes = {}
    towels.each do |chars|
      head = chars.shift
      @head_nodes[head] ||= Node.new(head, {}, false)
      prev_node = @head_nodes[head]
      chars.each do |c|
        prev_node.next[c] ||= Node.new(c, {}, false)
        prev_node = prev_node.next[c]
      end
      prev_node.terminal = true
    end
  end

  def count_possible(target, start_index, cache)
    return cache[start_index] unless cache[start_index].nil?

    count = 0
    i = start_index
    node = head_nodes[target[i]]
    until node.nil?
      i += 1

      if i == target.size
        count += 1 if node.terminal
        break
      end

      count += count_possible(target, i, cache) if node.terminal
      node = node.next[target[i]]
    end
    cache[start_index] = count
    cache[start_index]
  end

  def part1
    targets.filter { |t| count_possible(t, 0, {}) > 0 }.count
  end

  def part2
    targets.reduce(0) { |sum, t| sum + count_possible(t, 0, {}) }
  end
end

onsen = Onsen.create(IO.readlines(ARGV[0]))

puts onsen.part1
puts onsen.part2
