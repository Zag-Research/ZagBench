"""
ZagBench – BeRandom (Python port of BeRandom.class.st).

LCG parameters:
  seed        = 12345
  multiplier  = 1103515245
  increment   = 12345
  modulus     = 2^31  (= 2147483648)
  scale       = 1.0 / modulus
  next()      = (mult * rand + incr) % mod  →  rand * scale  (float in [0,1))
"""


class BeRandom:
    """Linear-congruential random-number generator matching Pharo's BeRandom."""

    def __init__(self):
        self._rand       = 12345
        self._multiplier = 1103515245
        self._increment  = 12345
        self._modulus    = 2147483648   # 2^31
        self._scale      = 1.0 / 2147483648

    def next(self):
        """Advance the LCG and return a float in [0, 1)."""
        self._rand = (self._multiplier * self._rand + self._increment) % self._modulus
        return self._rand * self._scale

    def next_integer(self, n):
        """Return a random integer in [1, n] (Pharo nextInteger: n)."""
        return int(self.next() * n) + 1

    def between(self, low, high):
        """Return a random integer in [low, high] inclusive."""
        return int(self.next() * (high - low + 1)) + low

    def random_square(self, size):
        """Return a size×size list-of-lists filled with next() values."""
        return [[self.next() for _ in range(size)] for _ in range(size)]

    def make_invertable(self, size):
        """Return a diagonally-dominant size×size matrix (guaranteed invertible).

        For each row, the diagonal element is set to the sum of the absolute
        values of all elements in that row (matching Pharo makeInvertable:).
        """
        matrix = self.random_square(size)
        for i in range(size):
            row     = matrix[i]
            row_sum = 0.0
            for v in row:
                row_sum += v if v >= 0.0 else -v
            row[i] = row_sum
        return matrix
