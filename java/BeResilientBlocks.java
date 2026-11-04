/**
 * ZagBench – BeResilientBlocks (Java port of BeResilientBlocks.class.st).
 *
 * Stresses object allocation by building linked lists of sizes 1..iterations-1
 * and summing their sizes.
 *
 * Verify: evaluate(2500) == 3123750   (= Σ i for i=1..2499 = 2499·2500/2)
 */
public class BeResilientBlocks extends Benchmark {

    @Override public int mainIterations()  { return 15; }
    @Override public int innerIterations() { return 2500; }

    @Override
    public boolean innerBenchmarkLoop(int innerIterations) {
        return verify(evaluate(innerIterations), innerIterations);
    }

    private long evaluate(int iterations) {
        long total = 0L;
        int  size  = 1;
        while (size < iterations) {
            total += BeResilientList.build(size).size();
            size++;
        }
        return total;
    }

    private boolean verify(long result, int iterations) {
        // Σ size for size = 1..iterations-1 (3123750 for the default 2500)
        long expected = (long) iterations * (iterations - 1) / 2;
        if (result == expected) return true;
        System.out.println("ResilientBlocks mismatch: got " + result + " expected " + expected);
        return false;
    }
}
