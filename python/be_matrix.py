"""
ZagBench – BeMatrix (Python port of BeMatrix.class.st / MatrixInversion-fixed).

Square matrix supporting:
  • element access / update
  • Gauss-Jordan inversion (no partial pivoting – matches fixed Pharo version)
  • matrix multiplication
  • identity-matrix check (epsilon = 1e-9)

No standard-library imports.
"""


class BeMatrix:
    """Dense square matrix stored as a list-of-lists of floats."""

    def __init__(self, size=0):
        self._matrix = [[0.0] * size for _ in range(size)]

    # ------------------------------------------------------------------
    # Factory helpers
    # ------------------------------------------------------------------

    @classmethod
    def with_data(cls, data):
        """Create a BeMatrix from a list-of-lists (makes a deep copy)."""
        obj = cls.__new__(cls)
        obj._matrix = [[float(v) for v in row] for row in data]
        return obj

    # ------------------------------------------------------------------
    # Element access (1-based matching Pharo at:and: / at:and:put:)
    # ------------------------------------------------------------------

    def at(self, row, col):
        """1-based element access."""
        return self._matrix[row - 1][col - 1]

    def at_put(self, row, col, value):
        """1-based element assignment."""
        self._matrix[row - 1][col - 1] = value

    # ------------------------------------------------------------------
    # Dimensions
    # ------------------------------------------------------------------

    def size(self):
        return len(self._matrix)

    def rows(self):
        return len(self._matrix)

    def columns(self):
        return len(self._matrix[0]) if self._matrix else 0

    # ------------------------------------------------------------------
    # Gauss-Jordan inversion (no partial pivoting)
    # ------------------------------------------------------------------

    def invert(self):
        """Return the inverse of self as a new BeMatrix.

        Implements Gauss-Jordan elimination on the augmented matrix [A | I].
        The source matrix must be invertible (BeRandom.make_invertable guarantees
        diagonal dominance, so no pivoting is needed).
        """
        n   = self.size()
        w   = n * 2    # augmented width

        # Build the n × 2n augmented matrix [A | I]
        aug = []
        for i in range(n):
            row = [float(self._matrix[i][k]) for k in range(n)]
            for j in range(n):
                row.append(1.0 if i == j else 0.0)
            aug.append(row)

        # Gauss-Jordan elimination
        for i in range(n):
            pivot = aug[i][i]
            for k in range(w):
                aug[i][k] /= pivot
            for r in range(n):
                if r != i:
                    factor = aug[r][i]
                    for k in range(w):
                        aug[r][k] -= factor * aug[i][k]

        # Extract right half (the inverse)
        result = BeMatrix(n)
        for i in range(n):
            for j in range(n):
                result._matrix[i][j] = aug[i][j + n]
        return result

    # ------------------------------------------------------------------
    # Matrix multiplication
    # ------------------------------------------------------------------

    def multiply(self, other):
        """Return self * other as a new BeMatrix."""
        n      = self.size()
        result = BeMatrix(n)
        for i in range(n):
            for j in range(n):
                s = 0.0
                for k in range(n):
                    s += self._matrix[i][k] * other._matrix[k][j]
                result._matrix[i][j] = s
        return result

    # ------------------------------------------------------------------
    # Identity check
    # ------------------------------------------------------------------

    def is_identity_matrix(self):
        """True iff self is within epsilon=1e-9 of the identity matrix."""
        epsilon = 1.0e-9
        n       = self.size()
        for i in range(n):
            for j in range(n):
                expected = 1.0 if i == j else 0.0
                diff = self._matrix[i][j] - expected
                if diff < 0.0:
                    diff = -diff
                if diff > epsilon:
                    return False
        return True
