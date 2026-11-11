"""
ZagBench – BeResilientList (Python port of BeResilientList.class.st).

A singly-linked list used to stress block/closure creation in
BeResilientBlocks.  Built iteratively (not recursively) to avoid
Python's default recursion limit for long chains.
"""


class BeResilientList:
    """One node in a singly-linked chain."""

    __slots__ = ("_next",)

    def __init__(self, next_node=None):
        self._next = next_node

    # ------------------------------------------------------------------
    # Construction
    # ------------------------------------------------------------------

    @classmethod
    def build(cls, size):
        """Build a chain of *size* nodes and return the head.

        Equivalent to Pharo's ``BeResilientList new: size`` (class method)
        which calls ``build: size from: nil``.  Iterative to avoid
        hitting Python's recursion limit for sizes > 1000.
        """
        head = None
        for _ in range(size):
            head = cls(head)
        return head

    # ------------------------------------------------------------------
    # Traversal helpers (mirror Pharo's do: / ifLast: / size)
    # ------------------------------------------------------------------

    def do(self, block):
        """Call block(node) for each node in the chain."""
        node = self
        while node is not None:
            block(node)
            node = node._next

    def if_last(self, block):
        """Call block() if this node is the last (next is None)."""
        if self._next is None:
            block()

    def size(self):
        """Return the number of nodes in the chain (O(n))."""
        n    = 0
        node = self
        while node is not None:
            n   += 1
            node = node._next
        return n
