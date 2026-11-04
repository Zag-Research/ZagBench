/**
 * ZagBench – BeMatrix (Java port of BeMatrix.class.st / MatrixInversion-fixed).
 *
 * Dense square matrix with Gauss-Jordan inversion (no partial pivoting),
 * matrix multiplication, and identity-matrix check (epsilon = 1e-9).
 * No java.util.* imports.
 */
public class BeMatrix {

    private final double[][] matrix;
    private final int        n;

    /** Create an n×n zero matrix. */
    public BeMatrix(int size) {
        this.n      = size;
        this.matrix = new double[size][size];
    }

    /** Create a BeMatrix wrapping (a deep copy of) the given 2-D array. */
    public static BeMatrix from(double[][] data) {
        int sz = data.length;
        BeMatrix m = new BeMatrix(sz);
        for (int i = 0; i < sz; i++)
            for (int j = 0; j < sz; j++) m.matrix[i][j] = data[i][j];
        return m;
    }

    // -----------------------------------------------------------------------
    // 1-based element access (matching Pharo at:and: / at:and:put:)
    // -----------------------------------------------------------------------

    public double at(int row, int col) {
        return matrix[row - 1][col - 1];
    }

    public void atPut(int row, int col, double value) {
        matrix[row - 1][col - 1] = value;
    }

    public int size()    { return n; }
    public int rows()    { return n; }
    public int columns() { return n; }

    // -----------------------------------------------------------------------
    // Gauss-Jordan inversion (no partial pivoting)
    // -----------------------------------------------------------------------

    /**
     * Return the inverse of self as a new BeMatrix.
     * Builds the augmented matrix [A | I], applies Gauss-Jordan elimination,
     * then extracts the right half.
     */
    public BeMatrix invert() {
        int      w   = n * 2;
        double[][] aug = new double[n][w];

        // Fill left half with A, right half with I
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) aug[i][j] = matrix[i][j];
            aug[i][i + n] = 1.0;
        }

        // Gauss-Jordan elimination
        for (int i = 0; i < n; i++) {
            double pivot = aug[i][i];
            for (int k = 0; k < w; k++) aug[i][k] /= pivot;
            for (int r = 0; r < n; r++) {
                if (r != i) {
                    double factor = aug[r][i];
                    for (int k = 0; k < w; k++) aug[r][k] -= factor * aug[i][k];
                }
            }
        }

        // Extract right half
        BeMatrix result = new BeMatrix(n);
        for (int i = 0; i < n; i++)
            for (int j = 0; j < n; j++) result.matrix[i][j] = aug[i][j + n];
        return result;
    }

    // -----------------------------------------------------------------------
    // Matrix multiplication
    // -----------------------------------------------------------------------

    /** Return self * other as a new BeMatrix. */
    public BeMatrix multiply(BeMatrix other) {
        BeMatrix result = new BeMatrix(n);
        for (int i = 0; i < n; i++)
            for (int j = 0; j < n; j++) {
                double s = 0.0;
                for (int k = 0; k < n; k++) s += matrix[i][k] * other.matrix[k][j];
                result.matrix[i][j] = s;
            }
        return result;
    }

    // -----------------------------------------------------------------------
    // Identity check
    // -----------------------------------------------------------------------

    /** True iff self is within epsilon=1e-9 of the identity matrix. */
    public boolean isIdentityMatrix() {
        double eps = 1.0e-9;
        for (int i = 0; i < n; i++)
            for (int j = 0; j < n; j++) {
                double expected = (i == j) ? 1.0 : 0.0;
                double diff     = matrix[i][j] - expected;
                if (diff < 0.0) diff = -diff;
                if (diff > eps) return false;
            }
        return true;
    }
}
