/**
 * ZagBench – BeMatrixInversion (Java port of BeMatrixInversion.class.st).
 *
 * Benchmarks matrix inversion + multiplication on a 10×10 matrix.
 * Verifies A^-1 * A ≈ I (epsilon = 1e-9).
 */
public class BeMatrixInversion extends Benchmark {

    @Override public int mainIterations()  { return 10; }
    @Override public int innerIterations() { return 250; }

    private final BeMatrix source;

    public BeMatrixInversion() {
        BeRandom rng = new BeRandom();
        source = BeMatrix.from(rng.makeInvertable(10));
    }

    @Override
    public boolean innerBenchmarkLoop(int innerIterations) {
        boolean result = true;
        for (int i = 0; i < innerIterations; i++) {
            result = result & multiplyInverse();
        }
        return result;
    }

    private boolean multiplyInverse() {
        BeMatrix inv    = source.invert();
        BeMatrix result = inv.multiply(source);
        return result.isIdentityMatrix();
    }
}
