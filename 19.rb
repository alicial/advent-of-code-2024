Node = Struct.new('Node', :char, :next, :terminal)

class Onsen
  attr_accessor :head_nodes, :targets

  def self.create(input)
    onsen = Onsen.new
    towels = input.shift.chomp.split(', ').map(&:chars)
    onsen.create_towel_tree(towels)
    input.shift
    onsen.targets = input.map(&:chomp).to_set
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

  def possible?(target, i)
    node = @head_nodes[target[i]]
    until node.nil?

      i += 1
      return true if node.terminal && (i == target.size || possible?(target, i))

      node = node.next[target[i]]
    end
    false
  end

  def part1
    targets.filter { |t| possible?(t, 0) }.count
  end
end

puts Onsen.create(IO.readlines(ARGV[0])).part1
