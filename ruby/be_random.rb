# ZagBench – BeRandom (Ruby port of BeRandom.class.st).
#
# LCG: seed=12345, mult=1103515245, incr=12345, mod=2^31, scale=1.0/2^31
# Ruby's Integer is arbitrary-precision, so no overflow risk.

class BeRandom
  MULTIPLIER = 1_103_515_245
  INCREMENT  = 12_345
  MODULUS    = 2**31             # 2147483648
  SCALE      = 1.0 / (2**31)

  def initialize
    @rand = 12_345
  end

  def next
    @rand = (MULTIPLIER * @rand + INCREMENT) % MODULUS
    @rand * SCALE
  end

  def next_integer(n)
    (self.next * n).to_i + 1
  end

  def between(low, high)
    (self.next * (high - low + 1)).to_i + low
  end

  def random_square(size)
    Array.new(size) { Array.new(size) { self.next } }
  end

  def make_invertable(size)
    m = random_square(size)
    size.times do |i|
      row_sum = 0.0
      m[i].each { |v| row_sum += v >= 0.0 ? v : -v }
      m[i][i] = row_sum
    end
    m
  end
end
