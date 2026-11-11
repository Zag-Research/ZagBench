/**
 * ZagBench – Java harness entry point.
 *
 * Usage:
 *   java Harness <BenchmarkName> [numIterations [innerIterations]]
 *
 * Example:
 *   java Harness MemoizedFibonacci
 *   java Harness Fannkuch 2 10
 *   java Harness MatrixInversion 10 250
 *   java Harness DataFrame 10 500
 *
 * Compile all .java files first:
 *   javac *.java
 * Run DataFrame from the directory containing mnist_test.csv.
 */
public class Harness {

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
        System.out.println("Usage: java Harness <benchmark> [num-iterations [inner-iter]]");
        System.out.println();
        System.out.println("  benchmark  BeMemoizedFibonacci | BeFannkuch | BeMatrixInversion |");
        System.out.println("             BeResilientBlocks   | BeStressGC | BeDataFrame");
    }
}
