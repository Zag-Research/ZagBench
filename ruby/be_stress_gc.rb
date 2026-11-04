# ZagBench – BeStressGC (Ruby port of BeStressGC.class.st).
#
# Stresses the GC by building a tree, then repeatedly chopping parts of it.
# Verifies the chop count for the default 10000 iterations (9901).

require_relative 'benchmark'
require_relative 'be_random'
require_relative 'be_random_tree_node'

class BeStressGC < Benchmark
  def self.main_iterations  = 10
  def self.inner_iterations = 10_000

  NODE_COUNT   = 1000
  MAX_CHILDREN = 4

  def initialize
    @random = BeRandom.new
    @tree   = nil
  end

  def inner_benchmark_loop(inner_iterations)
    chops = _benchmark(inner_iterations)
    # Known result for the default count (same in every port); others are not checked
    if inner_iterations == 10_000 && chops != 9901
      puts "StressGC chop count mismatch: got #{chops} expected 9901"
      return false
    end
    true
  end

  private

  def _benchmark(iterations)
    chop_count = 0
    _build
    (1..iterations).each do |i|
      if @tree.live_nodes > 1
        if i.odd?
          @tree.cut_half_subtrees
        else
          @tree.cut_random_subtree(@random)
        end
        chop_count += 1
      else
        _build
      end
    end
    chop_count
  end

  def _build
    @tree = BeRandomTreeNode.new
    @tree.value = 0

    # BFS using a plain array with a front-index pointer (O(1) dequeue)
    queue   = Array.new(NODE_COUNT + 1)
    q_head  = 0
    q_tail  = 0
    queue[q_tail] = @tree
    q_tail += 1

    created = 1
    while created < NODE_COUNT && q_head < q_tail
      current     = queue[q_head]
      q_head     += 1
      child_count = 1 + @random.next_integer(MAX_CHILDREN)
      child_count.times do
        break if created >= NODE_COUNT
        child       = BeRandomTreeNode.new
        child.value = created
        created    += 1
        current.add_child(child)
        queue[q_tail] = child
        q_tail       += 1
      end
    end
  end
end
