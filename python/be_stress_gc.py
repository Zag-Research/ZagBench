"""
ZagBench – BeStressGC (Python port of BeStressGC.class.st + BeRandomTreeNode).

Stresses the garbage collector by repeatedly chopping parts of a
randomly-built tree, triggering many short-lived object allocations.

Verifies the chop count for the default 10000 iterations (9901).
"""
from benchmark import Benchmark
from be_random import BeRandom
from be_random_tree_node import BeRandomTreeNode


class BeStressGC(Benchmark):
    """GC stress benchmark via tree build / chop cycles."""

    MAIN_ITERATIONS  = 10
    INNER_ITERATIONS = 10000

    # Tree parameters (matching Pharo's BeStressGC)
    _NODE_COUNT   = 1000
    _MAX_CHILDREN = 4

    def __init__(self):
        self._random = BeRandom()
        self._tree   = None

    def inner_benchmark_loop(self, iterations):
        chops = self._benchmark(iterations)
        # Known result for the default count (same in every port); others are not checked
        if iterations == 10000 and chops != 9901:
            print("StressGC chop count mismatch: got {} expected 9901".format(chops))
            return False
        return True

    # ------------------------------------------------------------------
    # Core benchmark
    # ------------------------------------------------------------------

    def _benchmark(self, iterations):
        """Alternate half-cut and random-cut; rebuild when tree is empty."""
        chop_count = 0
        self._build()
        for i in range(1, iterations + 1):
            if self._tree.live_nodes() > 1:
                if i % 2 == 1:
                    self._tree.cut_half_subtrees()
                else:
                    self._tree.cut_random_subtree(self._random)
                chop_count += 1
            else:
                self._build()
        return chop_count

    # ------------------------------------------------------------------
    # Tree construction (BFS)
    # ------------------------------------------------------------------

    def _build(self):
        """Build a random tree with at most NODE_COUNT nodes (BFS)."""
        root = BeRandomTreeNode()
        root.set_value(0)
        self._tree = root

        queue   = [root]
        q_start = 0
        created = 1

        while created < self._NODE_COUNT and q_start < len(queue):
            current     = queue[q_start]
            q_start    += 1
            child_count = 1 + self._random.next_integer(self._MAX_CHILDREN)
            for _ in range(child_count):
                if created < self._NODE_COUNT:
                    child = BeRandomTreeNode()
                    child.set_value(created)
                    current.add_child(child)
                    queue.append(child)
                    created += 1
