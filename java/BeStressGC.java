/**
 * ZagBench – BeStressGC (Java port of BeStressGC.class.st).
 *
 * Stresses the GC by repeatedly chopping parts of a randomly-built tree.
 * Verifies the chop count for the default 10000 iterations (9901).
 * No java.util.* imports.
 */
public class BeStressGC extends Benchmark {

    @Override public int mainIterations()  { return 10; }
    @Override public int innerIterations() { return 10000; }

    private static final int NODE_COUNT   = 1000;
    private static final int MAX_CHILDREN = 4;

    private final BeRandom       random = new BeRandom();
    private       BeRandomTreeNode tree;

    @Override
    public boolean innerBenchmarkLoop(int iterations) {
        int chops = benchmark(iterations);
        // Known result for the default count (same in every port); others are not checked
        if (iterations == 10000 && chops != 9901) {
            System.out.println("StressGC chop count mismatch: got " + chops + " expected 9901");
            return false;
        }
        return true;
    }

    // -----------------------------------------------------------------------
    // Core benchmark
    // -----------------------------------------------------------------------

    private int benchmark(int iterations) {
        int chopCount = 0;
        build();
        for (int i = 1; i <= iterations; i++) {
            if (tree.liveNodes() > 1) {
                if (i % 2 == 1) tree.cutHalfSubtrees();
                else            tree.cutRandomSubtree(random);
                chopCount++;
            } else {
                build();
            }
        }
        return chopCount;
    }

    // -----------------------------------------------------------------------
    // BFS tree construction
    // -----------------------------------------------------------------------

    private void build() {
        tree = new BeRandomTreeNode();
        tree.setValue(0);

        // Queue implemented as a plain array with front pointer
        BeRandomTreeNode[] queue = new BeRandomTreeNode[NODE_COUNT + 1];
        int qHead = 0, qTail = 0;
        queue[qTail++] = tree;

        int created = 1;
        while (created < NODE_COUNT && qHead < qTail) {
            BeRandomTreeNode current    = queue[qHead++];
            int              childCount = 1 + random.nextInteger(MAX_CHILDREN);
            for (int c = 0; c < childCount && created < NODE_COUNT; c++) {
                BeRandomTreeNode child = new BeRandomTreeNode();
                child.setValue(created++);
                current.addChild(child);
                queue[qTail++] = child;
            }
        }
    }
}
