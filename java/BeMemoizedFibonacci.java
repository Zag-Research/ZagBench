/**
 * ZagBench – BeMemoizedFibonacci (Java port of BeMemoizedFibonacci.class.st).
 *
 * Benchmarks Dictionary performance and LargeInteger arithmetic.
 * Uses the hand-rolled BeLargeInteger (no java.math.BigInteger) and the
 * hand-rolled BeIntMap cache, the same map algorithm as the Python, JS and
 * Ruby ports, so every language exercises identical dictionary code.
 */
public class BeMemoizedFibonacci extends Benchmark {

    @Override public int mainIterations()  { return 10; }
    @Override public int innerIterations() { return 250000; }

    private final BeIntMap<BeLargeInteger> cache = new BeIntMap<>();

    /** Return fib(n), building the cache bottom-up on first call. */
    public BeLargeInteger fibMemo(int n) {
        if (n <= 1) return BeLargeInteger.valueOf(n);
        BeLargeInteger hit = cache.get(n);
        if (hit != null) return hit;
        // Cache miss: build iteratively from 2 up to n (first call only)
        BeLargeInteger a = BeLargeInteger.ZERO;
        BeLargeInteger b = BeLargeInteger.ONE;
        for (int i = 2; i <= n; i++) {
            BeLargeInteger next = a.add(b);
            a = b;
            b = next;
            cache.put(i, b);
        }
        return cache.get(n);
    }

    @Override
    public boolean innerBenchmarkLoop(int innerIterations) {
        BeLargeInteger result = null;
        for (int i = 0; i < innerIterations; i++) {
            result = fibMemo(200000);
        }
        // fib(200000) mod 1e9+7, identical in every port
        if (result != null && result.mod(1000000007) != 216653165) {
            System.out.println("Fibonacci mismatch: fib(200000) mod 1e9+7 = " + result.mod(1000000007));
            return false;
        }
        return true;
    }
}
