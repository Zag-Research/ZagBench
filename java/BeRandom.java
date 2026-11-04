/**
 * ZagBench – BeRandom (Java port of BeRandom.class.st).
 *
 * LCG parameters:
 *   seed        = 12345
 *   multiplier  = 1103515245
 *   increment   = 12345
 *   modulus     = 2^31 = 2147483648
 *   scale       = 1.0 / modulus
 *   next()      = (mult * rand + incr) % mod  →  rand * scale  (double in [0,1))
 *
 * No java.util.* imports.
 */
public class BeRandom {

    private long   rand       = 12345L;
    private static final long MULTIPLIER = 1103515245L;
    private static final long INCREMENT  = 12345L;
    private static final long MODULUS    = 2147483648L;   // 2^31
    private static final double SCALE    = 1.0 / 2147483648.0;

    /** Advance the LCG and return a double in [0, 1). */
    public double next() {
        rand = (MULTIPLIER * rand + INCREMENT) % MODULUS;
        return rand * SCALE;
    }

    /** Return a random int in [1, n]. */
    public int nextInteger(int n) {
        return (int)(next() * n) + 1;
    }

    /** Return a random int in [low, high] inclusive. */
    public int between(int low, int high) {
        return (int)(next() * (high - low + 1)) + low;
    }

    /** Return a size×size 2-D array filled with next() values. */
    public double[][] randomSquare(int size) {
        double[][] m = new double[size][size];
        for (int i = 0; i < size; i++)
            for (int j = 0; j < size; j++)
                m[i][j] = next();
        return m;
    }

    /**
     * Return a diagonally-dominant size×size matrix (guaranteed invertible).
     * For each row, diagonal = sum of |element| for all elements in that row.
     */
    public double[][] makeInvertable(int size) {
        double[][] m = randomSquare(size);
        for (int i = 0; i < size; i++) {
            double rowSum = 0.0;
            for (int j = 0; j < size; j++) {
                rowSum += (m[i][j] >= 0.0) ? m[i][j] : -m[i][j];
            }
            m[i][i] = rowSum;
        }
        return m;
    }
}
