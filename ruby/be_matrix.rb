# ZagBench – BeMatrix (Ruby port of BeMatrix.class.st + MatrixInversion-fixed).
#
# 1-based row/col accessors, Gauss-Jordan (no partial pivoting), identity check.
# All copying is hand-rolled (no map / dup / slice / abs).

require_relative 'benchmark'
require_relative 'be_random'

class BeMatrix
  # Create an n×n zero matrix, or a deep copy of source (an n×n 2-D array).
  def initialize(n, source = nil)
    @n    = n
    @data = Array.new(n) { Array.new(n, 0.0) }
    n.times { |i| n.times { |j| @data[i][j] = source[i][j] } } if source
  end

  # Create a BeMatrix holding a deep copy of the given 2-D array.
  def self.with_data(data)
    new(data.length, data)
  end

  def n = @n

  # 1-based accessors
  def at(row, col)               = @data[row - 1][col - 1]
  def at_put(row, col, value)    ; @data[row - 1][col - 1] = value ; end

  # Gauss-Jordan inversion (no partial pivoting, matches Pharo original).
  def invert
    n  = @n
    # Build augmented n × 2n matrix
    aug = Array.new(n) do |i|
      row = Array.new(2 * n, 0.0)
      n.times { |j| row[j] = @data[i][j] }
      row[n + i] = 1.0
      row
    end

    # Normalise the pivot row, then eliminate the column from every other row
    # (same operation order as the Java and Python ports).
    w = 2 * n
    n.times do |i|
      pivot = aug[i][i]
      w.times { |k| aug[i][k] /= pivot }
      n.times do |r|
        next if r == i
        factor = aug[r][i]
        w.times { |k| aug[r][k] -= factor * aug[i][k] }
      end
    end

    # Extract right half (written straight into the result, like Java)
    result = BeMatrix.new(n)
    rd     = result.data
    n.times { |i| n.times { |j| rd[i][j] = aug[i][j + n] } }
    result
  end

  # O(n^3) matrix multiply
  def multiply(other)
    n      = @n
    od     = other.data   # direct element access, like Java/Python
    result = BeMatrix.new(n)
    rd     = result.data
    n.times do |i|
      n.times do |j|
        s = 0.0
        n.times { |k| s += @data[i][k] * od[k][j] }
        rd[i][j] = s
      end
    end
    result
  end

  # Identity check with epsilon = 1e-9
  def identity_matrix?
    eps = 1e-9
    @n.times do |i|
      @n.times do |j|
        expected = i == j ? 1.0 : 0.0
        diff = @data[i][j] - expected
        diff = -diff if diff < 0.0
        return false if diff > eps
      end
    end
    true
  end

  protected

  attr_reader :data
end
