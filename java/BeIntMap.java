/**
 * ZagBench – BeIntMap: hand-rolled hash map from int keys to object values.
 *
 * Open addressing with linear probing, power-of-two capacity (starts at 8),
 * grows x2 when it would exceed 50% load. The same algorithm is used in the
 * Python, JavaScript and Ruby ports, so every language runs identical
 * dictionary code (no java.util.*, no dict / Map / Hash).
 */
public class BeIntMap<V> {

    private int[]    keys   = new int[8];
    private Object[] values = new Object[8];
    private boolean[] used  = new boolean[8];
    private int      count  = 0;

    /** Fibonacci hashing: spreads sequential keys across the table. */
    private static int slot(int key, int mask) {
        int h = key * 0x9E3779B1;
        return (h ^ (h >>> 16)) & mask;
    }

    /** Return the value stored for key, or null if absent. */
    @SuppressWarnings("unchecked")
    public V get(int key) {
        int mask = keys.length - 1;
        int i    = slot(key, mask);
        while (used[i]) {
            if (keys[i] == key) return (V) values[i];
            i = (i + 1) & mask;
        }
        return null;
    }

    /** Store value for key (replacing any existing value). */
    public void put(int key, V value) {
        if ((count + 1) * 2 > keys.length) grow();
        int mask = keys.length - 1;
        int i    = slot(key, mask);
        while (used[i]) {
            if (keys[i] == key) { values[i] = value; return; }
            i = (i + 1) & mask;
        }
        used[i] = true; keys[i] = key; values[i] = value; count++;
    }

    public int size() { return count; }

    private void grow() {
        int[]     oldKeys   = keys;
        Object[]  oldValues = values;
        boolean[] oldUsed   = used;
        int cap = oldKeys.length * 2;
        keys = new int[cap]; values = new Object[cap]; used = new boolean[cap]; count = 0;
        for (int i = 0; i < oldKeys.length; i++) {
            if (oldUsed[i]) {
                int mask = cap - 1;
                int j    = slot(oldKeys[i], mask);
                while (used[j]) j = (j + 1) & mask;
                used[j] = true; keys[j] = oldKeys[i]; values[j] = oldValues[i]; count++;
            }
        }
    }
}
