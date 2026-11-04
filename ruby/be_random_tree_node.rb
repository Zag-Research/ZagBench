# ZagBench – BeRandomTreeNode (Ruby port of BeRandomTreeNode.class.st).
#
# Tree node used by BeStressGC.  Iterative DFS for all_nodes.

class BeRandomTreeNode
  attr_accessor :value, :parent
  attr_reader   :children

  def initialize
    @value    = 0
    @parent   = nil
    @children = []
  end

  def add_child(node)
    node.parent = self
    @children << node
  end

  # Approximate Pharo's liveNodes: direct children + self
  def live_nodes = @children.length + 1

  # Iterative DFS – avoids stack overflow on large trees
  def all_nodes
    result = []
    stack  = [self]
    until stack.empty?
      node   = stack.pop
      result << node
      children = node.children
      i = children.length - 1
      while i >= 0
        stack << children[i]
        i -= 1
      end
    end
    result
  end

  def subtree_size
    total = 1
    @children.each { |c| total += c.subtree_size }
    total
  end

  # Remove the first half of direct children (Pharo cutHalfSubtrees)
  def cut_half_subtrees
    half    = @children.length / 2
    victims = Array.new(half)
    half.times { |i| victims[i] = @children[i] }
    victims.each { |v| remove_child(v) }
    self
  end

  # Remove a randomly chosen non-root node (Pharo cutRandomSubtree:)
  def cut_random_subtree(random)
    all  = all_nodes
    return self if all.length <= 1
    # Skip root (index 0); nextInteger returns 1-based in [1, n-1]
    idx  = random.next_integer(all.length - 1)
    pick = all[idx]
    pick.parent&.remove_child(pick)
    self
  end

  # Scan for node, shift later children left (like Java's removeChildAt)
  def remove_child(node)
    children = @children
    n = children.length
    i = 0
    while i < n
      if children[i].equal?(node)
        j = i
        while j < n - 1
          children[j] = children[j + 1]
          j += 1
        end
        children.pop
        return
      end
      i += 1
    end
  end
end
