"""
ZagBench – BeDataFrame (Python port of BeDataFrame.class.st).

Benchmarks hand-rolled CSV parsing (no csv module).
Reads mnist_test.csv from the current working directory.
Verifies: numberOfColumns == 785 and numberOfRows == inner_iterations.

Run the harness from the directory containing mnist_test.csv.
"""
from benchmark import Benchmark


class BeDataFrame(Benchmark):
    """Loads a CSV file using a hand-rolled tokeniser."""

    MAIN_ITERATIONS  = 10
    INNER_ITERATIONS = 500

    def __init__(self):
        self._column_names = []
        self._rows         = []

    # ------------------------------------------------------------------
    # Benchmark loop
    # ------------------------------------------------------------------

    def inner_benchmark_loop(self, inner_iterations):
        return self._verify(self._load_data_frame(inner_iterations), inner_iterations)

    # ------------------------------------------------------------------
    # Hand-rolled CSV parser (mirrors Pharo's findTokens: ',' / trimToken:)
    # ------------------------------------------------------------------

    @staticmethod
    def _is_trimmable(ch):
        return ch == ' ' or ch == '\t' or ch == '\r' or ch == '\n'

    @classmethod
    def _trim_token(cls, s):
        """Strip leading and trailing whitespace (Pharo trimToken:)."""
        start = 0
        stop  = len(s) - 1
        while start <= stop and cls._is_trimmable(s[start]):
            start += 1
        while stop >= start and cls._is_trimmable(s[stop]):
            stop -= 1
        return s[start : stop + 1]

    @classmethod
    def _split_csv_line(cls, line):
        """Split *line* on commas and trim each token."""
        tokens = []
        start  = 0
        for i in range(len(line)):
            if line[i] == ',':
                tokens.append(cls._trim_token(line[start:i]))
                start = i + 1
        tokens.append(cls._trim_token(line[start:]))
        return tokens

    # ------------------------------------------------------------------
    # Data loading
    # ------------------------------------------------------------------

    def _load_data_frame(self, inner_iterations):
        """Read the CSV file and populate column_names + rows (in-place).

        Streams line by line and stops after header + inner_iterations rows,
        matching the Java (BufferedReader) and Ruby (File#gets) ports.
        """
        try:
            f = open("mnist_test.csv", "r")
        except FileNotFoundError:
            raise RuntimeError("Cannot read mnist_test.csv. Run DataFrame from the "
                               "folder that contains mnist_test.csv.") from None
        with f:
            self._column_names = self._split_csv_line(self._chomp(f.readline()))
            self._rows         = []
            while len(self._rows) < inner_iterations:
                line = f.readline()
                if not line:
                    break
                self._rows.append(self._split_csv_line(self._chomp(line)))
        return self

    @staticmethod
    def _chomp(line):
        """Drop the trailing newline (text mode already folds CRLF to LF)."""
        if line and line[-1] == '\n':
            return line[:-1]
        return line

    # ------------------------------------------------------------------
    # Public accessors
    # ------------------------------------------------------------------

    def number_of_columns(self):
        return len(self._column_names)

    def number_of_rows(self):
        return len(self._rows)

    def column_names(self):
        return self._column_names

    def row_at(self, index):
        """0-based row access."""
        return self._rows[index]

    # ------------------------------------------------------------------
    # Verification (matches Pharo's verify:inner:)
    # ------------------------------------------------------------------

    def _verify(self, result, inner_iterations):
        if not isinstance(result, BeDataFrame):
            return False
        if result.number_of_rows() != inner_iterations:
            print("Row count mismatch: got {} expected {}".format(
                result.number_of_rows(), inner_iterations))
            return False
        if result.number_of_columns() != 785:
            print("Column count mismatch: got {} expected 785".format(
                result.number_of_columns()))
            return False
        return True
