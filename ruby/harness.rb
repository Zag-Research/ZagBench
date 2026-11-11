#!/usr/bin/env ruby
# ZagBench – Ruby harness entry point.
# Usage: ruby harness.rb <BenchmarkName> [numIterations [innerIterations]]
#
# Example:
#   ruby harness.rb MemoizedFibonacci
#   ruby harness.rb Fannkuch 2 10
#   ruby harness.rb MatrixInversion 10 250
#   ruby harness.rb DataFrame 10 500

$LOAD_PATH.unshift(__dir__)
require_relative 'run'

def print_usage
  puts "Usage: ruby harness.rb <benchmark> [num-iterations [inner-iter]]"
  puts
  puts "  benchmark  BeMemoizedFibonacci | BeFannkuch | BeMatrixInversion |"
  puts "             BeResilientBlocks   | BeStressGC | BeDataFrame"
end

if ARGV.length < 1
  print_usage
  exit 1
end

# Parse a whole number >= 1, or print usage and exit 1.
def parse_positive(s, what)
  unless s.match?(/\A\d+\z/) && s.to_i >= 1
    puts "Error: #{what} must be a whole number >= 1, got '#{s}'"
    print_usage
    exit 1
  end
  s.to_i
end

run = Run.new(ARGV[0])
run.set_num_iterations(parse_positive(ARGV[1], 'num-iterations'))   if ARGV[1]
run.set_inner_iterations(parse_positive(ARGV[2], 'inner-iter'))     if ARGV[2]

run.run_benchmark
run.print_total
