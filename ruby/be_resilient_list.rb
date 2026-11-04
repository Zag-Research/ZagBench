# ZagBench – BeResilientList (Ruby port of BeResilientList.class.st).
#
# Immutable singly-linked list node; iterative build to avoid stack overflow.

class BeResilientList
  attr_reader :next_node

  def initialize(next_node)
    @next_node = next_node
  end

  # Iterative factory: avoids deep recursion for sizes up to 2499.
  def self.build(size)
    head = nil
    size.times { head = new(head) }
    head
  end

  def size
    count = 0
    node  = self
    while node
      count += 1
      node   = node.next_node
    end
    count
  end
end
