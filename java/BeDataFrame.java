import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

/**
 * ZagBench – BeDataFrame (Java port of BeDataFrame.class.st).
 *
 * Benchmarks hand-rolled CSV parsing.  File I/O uses java.io (unavoidable
 * in Java; not a computational library).  The CSV tokeniser and the column/
 * row storage are entirely hand-rolled (no java.util.* for data structures).
 *
 * Verifies: numberOfColumns == 785 and numberOfRows == innerIterations.
 *
 * Run the harness from the directory containing mnist_test.csv.
 */
public class BeDataFrame extends Benchmark {

    @Override public int mainIterations()  { return 10; }
    @Override public int innerIterations() { return 500; }

    private static final int MAX_COLS = 800;   // > 785

    // Hand-rolled storage: array of column-name strings, 2-D row array
    private String[]   columnNames;
    private int        numColumns;
    private String[][] rows;
    private int        numRows;

    @Override
    public boolean innerBenchmarkLoop(int innerIterations) {
        loadDataFrame(innerIterations);
        return verify(innerIterations);
    }

    // -----------------------------------------------------------------------
    // Hand-rolled CSV parser
    // -----------------------------------------------------------------------

    private static boolean isTrimmable(char ch) {
        return ch == ' ' || ch == '\t' || ch == '\r' || ch == '\n';
    }

    private static String trimToken(String s) {
        int start = 0, stop = s.length() - 1;
        while (start <= stop && isTrimmable(s.charAt(start)))  start++;
        while (stop >= start && isTrimmable(s.charAt(stop)))   stop--;
        return (start > stop) ? "" : s.substring(start, stop + 1);
    }

    /** Split a CSV line on commas, trim each token, fill into dest[]. Returns count. */
    private static int splitCSVLine(String line, String[] dest) {
        int count = 0, start = 0, len = line.length();
        for (int i = 0; i < len; i++) {
            if (line.charAt(i) == ',') {
                if (count < dest.length) dest[count++] = trimToken(line.substring(start, i));
                start = i + 1;
            }
        }
        if (count < dest.length) dest[count++] = trimToken(line.substring(start));
        return count;
    }

    // -----------------------------------------------------------------------
    // Data loading
    // -----------------------------------------------------------------------

    private void loadDataFrame(int innerIterations) {
        String[] buf = new String[MAX_COLS];
        try (BufferedReader br = new BufferedReader(new FileReader("mnist_test.csv"))) {
            // Header line
            String headerLine = br.readLine();
            numColumns   = splitCSVLine(headerLine, buf);
            columnNames  = new String[numColumns];
            for (int i = 0; i < numColumns; i++) columnNames[i] = buf[i];

            // Data rows
            rows    = new String[innerIterations][numColumns];
            numRows = 0;
            String line;
            // Check the row count first so no line past the last needed one is read
            while (numRows < innerIterations && (line = br.readLine()) != null) {
                splitCSVLine(line, rows[numRows]);
                numRows++;
            }
        } catch (IOException e) {
            throw new RuntimeException("Cannot read mnist_test.csv (" + e.getMessage()
                + "). Run DataFrame from the folder that contains mnist_test.csv.");
        }
    }

    // -----------------------------------------------------------------------
    // Public accessors / verification
    // -----------------------------------------------------------------------

    public int numberOfColumns() { return numColumns; }
    public int numberOfRows()    { return numRows; }

    private boolean verify(int innerIterations) {
        if (numRows != innerIterations) {
            System.out.println("Row count mismatch: got " + numRows + " expected " + innerIterations);
            return false;
        }
        if (numColumns != 785) {
            System.out.println("Column count mismatch: got " + numColumns + " expected 785");
            return false;
        }
        return true;
    }
}
