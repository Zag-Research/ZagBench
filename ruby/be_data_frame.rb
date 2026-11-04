# ZagBench – BeDataFrame (Ruby port of BeDataFrame.class.st).
#
# Benchmarks hand-rolled CSV parsing of mnist_test.csv.
# File I/O uses Ruby's built-in File class (infrastructure, not algorithm).
# CSV tokeniser, row/column storage are entirely hand-rolled.
#
# Verifies: numberOfColumns == 785 and numberOfRows == innerIterations.
# Run from the directory containing mnist_test.csv.

require_relative 'benchmark'

class BeDataFrame < Benchmark
  def self.main_iterations  = 10
  def self.inner_iterations = 500

  def initialize
    @column_names = []
    @rows         = []
  end

  def num_columns = @column_names.length
  def num_rows    = @rows.length

  def inner_benchmark_loop(inner_iterations)
    _load_data_frame(inner_iterations)
    _verify(inner_iterations)
  end

  private

  # Hand-rolled CSV token trimmer: removes spaces, tabs, CR, LF.
  def _trim_token(s)
    start = 0
    stop  = s.length - 1
    start += 1 while start <= stop && _trimmable?(s[start])
    stop  -= 1 while stop >= start && _trimmable?(s[stop])
    start > stop ? '' : s[start..stop]
  end

  # Hand-rolled chomp: drop a trailing "\n" or "\r\n".
  def _chomp(line)
    stop = line.length
    stop -= 1 if stop > 0 && line[stop - 1] == "\n"
    stop -= 1 if stop > 0 && line[stop - 1] == "\r"
    line[0, stop]
  end

  def _trimmable?(ch)
    ch == ' ' || ch == "\t" || ch == "\r" || ch == "\n"
  end

  # Split a CSV line on commas, returning an array of trimmed tokens.
  def _split_csv_line(line)
    tokens = []
    start  = 0
    n      = line.length
    i      = 0
    while i < n
      if line[i] == ','
        tokens << _trim_token(line[start, i - start])
        start = i + 1
      end
      i += 1
    end
    tokens << _trim_token(line[start, n - start])
    tokens
  end

  def _load_data_frame(inner_iterations)
    unless File.exist?('mnist_test.csv')
      raise 'Cannot read mnist_test.csv. Run DataFrame from the folder that contains mnist_test.csv.'
    end
    File.open('mnist_test.csv', 'r') do |f|
      # Header
      header        = f.gets
      @column_names = _split_csv_line(_chomp(header))

      # Data rows (stop before reading past the last needed line)
      @rows = []
      while @rows.length < inner_iterations
        line = f.gets
        break unless line
        @rows << _split_csv_line(_chomp(line))
      end
    end
  end

  def _verify(inner_iterations)
    unless @rows.length == inner_iterations
      puts "Row count mismatch: got #{@rows.length} expected #{inner_iterations}"
      return false
    end
    unless @column_names.length == 785
      puts "Column count mismatch: got #{@column_names.length} expected 785"
      return false
    end
    true
  end
end
