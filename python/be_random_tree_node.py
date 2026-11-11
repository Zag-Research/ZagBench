"""
ZagBench – BeRandomTreeNode (Python port of BeRandomTreeNode.class.st).

A tree node used by BeStressGC to stress garbage collection.
Supports BFS tree construction, half-subtree cutting, and random-subtree cutting.
"""


class BeRandomTreeNode:
    """One node in a randomly-built tree."""

    __slots__ = ("_value", "_parent", "_children")

    def __init__(self):
        self._value    = None
        self._parent   = None
        self._children = []     # list of BeRandomTreeNode

    # ------------------------------------------------------------------
    # Accessors
    # ------------------------------------------------------------------

    def value(self):
        return self._value

    def set_value(self, v):
        self._value = v

    def parent(self):
        return self._parent

    def set_parent(self, p):
        self._parent = p

    def children(self):
        return self._children

    # ------------------------------------------------------------------
    # Tree building
    # ------------------------------------------------------------------

    def add_child(self, node):
        """Add *node* as a child of self (also sets node's parent)."""
        node.set_parent(self)
        self._children.append(node)

    # ------------------------------------------------------------------
    # Tree queries
    # ------------------------------------------------------------------

    def all_nodes(self):
        """Return a flat list of self and all descendants (DFS pre-order).

        Iterative DFS with an explicit stack; children are pushed in reverse
        order by index so the leftmost is visited first (same as Java).
        """
        result = []
        stack  = [self]
        while stack:
            node = stack.pop()
            result.append(node)
            children = node._children
            i = len(children) - 1
            while i >= 0:
                stack.append(children[i])
                i -= 1
        return result

    def live_nodes(self):
        """Number of direct children plus self (matches Pharo's liveNodes)."""
        return len(self._children) + 1

    def subtree_size(self):
        """Total number of nodes in the subtree rooted at self."""
        total = 1
        for child in self._children:
            total += child.subtree_size()
        return total

    # ------------------------------------------------------------------
    # Subtree cutting
    # ------------------------------------------------------------------

    def _remove_child(self, node):
        """Remove *node* from children: scan, shift later children left (like Java)."""
        children = self._children
        n = len(children)
        for i in range(n):
            if children[i] is node:
                for j in range(i, n - 1):
                    children[j] = children[j + 1]
                children.pop()
                return

    def cut_half_subtrees(self):
        """Remove the first half of self's direct children (Pharo cutHalfSubtrees)."""
        half    = len(self._children) // 2
        victims = [None] * half
        for i in range(half):
            victims[i] = self._children[i]
        for v in victims:
            self._remove_child(v)
        return self

    def cut_random_subtree(self, random):
        """Remove a randomly chosen non-root node (Pharo cutRandomSubtree:)."""
        all_nodes = self.all_nodes()
        if len(all_nodes) <= 1:
            return self
        # Skip root (index 0); next_integer returns 1-based in [1, n-1]
        pick     = all_nodes[random.next_integer(len(all_nodes) - 1)]
        pick_par = pick.parent()
        if pick_par is not None:
            pick_par._remove_child(pick)
        return self
