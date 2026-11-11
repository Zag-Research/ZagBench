/**
 * ZagBench – abstract Benchmark base class (Java port of Benchmark.class.st).
 * No java.util.* imports in benchmark logic; subclasses hand-roll all algorithms.
 */
public abstract class Benchmark {

    /** Default outer (timed) iteration count – override in subclass. */
    public int mainIterations()  { return 10; }

    /** Default inner loop count per timed run – override in subclass. */
    public int innerIterations() { return 250000; }

    /**
     * Run the benchmark for {@code innerIterations} and return {@code true}
     * iff the result is correct.
     */
    public abstract boolean innerBenchmarkLoop(int innerIterations);
}
