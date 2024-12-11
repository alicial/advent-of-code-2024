class Stones
  attr_reader :cache, :stones

  def self.create(input)
    Stones.new(input.split.map(&:to_i))
  end

  def initialize(stones)
    @cache = {}
    @stones = stones
  end

  def digits_size(num)
    Math.log10(num).to_i + 1
  end

  def split(num)
    half_digits = digits_size(num) / 2
    divisor = 10**half_digits

    [num / divisor, num % divisor]
  end

  def calc_next(num)
    if num.zero?
      1
    elsif digits_size(num).even?
      split(num)
    else
      num * 2024
    end
  end

  def stone_size(num, rounds)
    return 1 if rounds == 0
    return cache[[num, rounds]] if cache[[num, rounds]]

    num1, num2 = calc_next(num)
    size = stone_size(num1, rounds - 1)
    size += stone_size(num2, rounds - 1) if num2

    cache[[num, rounds]] = size
    size
  end

  def size_after(rounds)
    stones.reduce(0) { |sum, num| sum + stone_size(num, rounds) }
  end
end

input = '0 37551 469 63 1 791606 2065 9983586'

stones = Stones.create(input)

puts stones.size_after(25)
puts stones.size_after(75)
