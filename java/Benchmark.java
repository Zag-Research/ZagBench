/**
 * ZagBench – abstract Benchmark base class (Java port of Benchmark.class.st).
 * No java.util.* imports in benchmark logic; subclasses hand-roll all algorithms.
 */
public class Benchmark {

    /** Default outer (timed) iteration count – override in subclass. */
    public int mainIterations()  { return 10; }

    /** Default inner loop count per timed run – override in subclass. */
    public int innerIterations() { return 250000; }

    /**
     * Run the benchmark for {@code innerIterations} and return {@code true}
     * iff the result is correct.
     */
    public boolean innerBenchmarkLoop(int innerIterations) {
        return false;
    }
    public static void main(String[] args) {
        if (args.length < 1) {
            printUsage();
            System.exit(1);
        }

        Run run = new Run(args[0]);
        if (args.length > 1) run.setNumIterations(parsePositive(args[1], "num-iterations"));
        if (args.length > 2) run.setInnerIterations(parsePositive(args[2], "inner-iter"));

        run.runBenchmark();
        run.printTotal();
    }

    /** Parse a whole number >= 1, or print usage and exit 1. */
    private static int parsePositive(String s, String what) {
        int n = 0;
        try {
            n = Integer.parseInt(s);
        } catch (NumberFormatException e) {
            n = 0;
        }
        if (n < 1) {
            System.out.println("Error: " + what + " must be a whole number >= 1, got '" + s + "'");
            printUsage();
            System.exit(1);
        }
        return n;
    }

    /** Factory: create a fresh benchmark instance by name (no reflection). */
    public static Benchmark createBenchmark(String name) {
        switch (name.toLowerCase()) {
            case "memoizedfibonacci":
            case "bememoizedfibonacci":   return new BeMemoizedFibonacci();
            case "fannkuch":
            case "befannkuch":            return new BeFannkuch();
            case "matrixinversion":
            case "bematrixinversion":     return new BeMatrixInversion();
            case "resilientblocks":
            case "beresilientblocks":     return new BeResilientBlocks();
            case "stressgc":
            case "bestressgc":            return new BeStressGC();
            case "dataframe":
            case "bedataframe":           return new BeDataFrame();
            default:
                throw new RuntimeException("Unknown benchmark: " + name);
        }
    }

    private static void printUsage() {
        System.out.println("Usage: java Benchmark <benchmark> [num-iterations [inner-iter]]");
        System.out.println();
        System.out.println("  benchmark  BeMemoizedFibonacci | BeFannkuch | BeMatrixInversion |");
        System.out.println("             BeResilientBlocks   | BeStressGC | BeDataFrame");
    }
    /**
     * ZagBench – Run / harness class (Java port of Benchmark.class.st timing logic).
     *
     * Hand-rolled helpers: Newton sqrt, insertion sort, quartiles.
     * Only java.lang.* (auto-imported) is used – no java.util.* in this file.
     */
    public static class Run {

        private final String name;
        private int    numIterations;   // -1 = use benchmark default
        private int    innerIterations; // -1 = use benchmark default
        private long   total;
        private long   totalSq;
        private long[] times;
        private int    timeCount;

        public Run(String name) {
            this.name            = name;
            this.numIterations   = -1;
            this.innerIterations = -1;
            this.total           = 0L;
            this.totalSq         = 0L;
        }

        public void setNumIterations(int n)   { this.numIterations   = n; }
        public void setInnerIterations(int n) { this.innerIterations = n; }

        // -----------------------------------------------------------------------
        // Public API
        // -----------------------------------------------------------------------

        public void runBenchmark() {
            System.out.println("Starting " + name + " benchmark ...");
            System.out.flush();

            Benchmark bench = createBenchmark(name);

            int ni = (numIterations   >= 0) ? numIterations   : bench.mainIterations();
            int ii = (innerIterations >= 0) ? innerIterations : bench.innerIterations();
            numIterations = ni;

            times     = new long[ni];
            timeCount = 0;

            for (int i = 0; i < ni; i++) {
                bench = createBenchmark(name); // fresh instance per run
                measure(bench, ii);
            }
        }

        public void printTotal() {
            report();
        }

        // -----------------------------------------------------------------------
        // Private timing & stats
        // -----------------------------------------------------------------------

        private void measure(Benchmark bench, int ii) {
            long startUs = System.nanoTime() / 1000L;
            boolean ok   = bench.innerBenchmarkLoop(ii);
            long endUs   = System.nanoTime() / 1000L;

            if (!ok) throw new RuntimeException("Benchmark failed with incorrect result");

            long runTime = endUs - startUs;
            times[timeCount++] = runTime;
            totalSq += runTime * runTime;
            total   += runTime;
        }

        private long mean() {
            return total / numIterations;
        }

        /** Newton's-method sqrt – no Math.sqrt. */
        private static double mySqrt(double x) {
            if (x <= 0.0) return 0.0;
            double g = x / 2.0;
            for (int i = 0; i < 200; i++) {
                double ng = (g + x / g) * 0.5;
                double diff = ng - g;
                if (diff < 0.0) diff = -diff;
                if (diff < 1.0e-15 * g) return ng;
                g = ng;
            }
            return g;
        }

        private double stdDev() {
            double mn  = (double) total / numIterations;
            double var = (double) totalSq / numIterations - mn * mn;
            return mySqrt(var);
        }

        // -----------------------------------------------------------------------
        // Insertion sort and quartiles
        // -----------------------------------------------------------------------

        private static void insertionSort(long[] arr, int n) {
            for (int i = 1; i < n; i++) {
                long key = arr[i];
                int  j   = i - 1;
                while (j >= 0 && arr[j] > key) {
                    arr[j + 1] = arr[j];
                    j--;
                }
                arr[j + 1] = key;
            }
        }

        private static long medianOf(long[] sorted, int from, int to) {
            int len = to - from;
            if (len <= 0) return 0L;
            int mid = from + len / 2;
            if (len % 2 == 1) return sorted[mid];
            return (sorted[mid - 1] + sorted[mid]) / 2;
        }

        /** Returns [Q1, median, Q3]. */
        private long[] quartiles() {
            long[] s = new long[timeCount];
            for (int i = 0; i < timeCount; i++) s[i] = times[i];
            insertionSort(s, timeCount);
            int n   = timeCount;
            int mid = n / 2;
            long median = medianOf(s, 0, n);
            if (n < 2) return new long[]{median, median, median}; // halves are empty
            long q1    = medianOf(s, 0, mid);
            long q3     = (n % 2 == 1) ? medianOf(s, mid + 1, n) : medianOf(s, mid, n);
            return new long[]{q1, median, q3};
        }

        private void report() {
            int    n      = numIterations;
            long   mn     = mean();
            double sd     = stdDev();
            double pct    = (mn > 0) ? (sd / mn * 100.0) : 0.0;
            long[] qs     = quartiles();
            long   minT   = times[0], maxT = times[0];
            for (int i = 1; i < timeCount; i++) {
                if (times[i] < minT) minT = times[i];
                if (times[i] > maxT) maxT = times[i];
            }
            System.out.printf(
                "%s: n=%d mean: %dus stdDev: %dus (%.1f%%) min: %dus 1stQ: %dus median: %dus 3rdQ: %dus max: %dus%n",
                name, n, mn, (long) sd, pct, minT, qs[0], qs[1], qs[2], maxT
            );
        }
    }

}
