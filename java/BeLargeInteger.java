/**
 * ZagBench – BeLargeInteger: hand-rolled non-negative arbitrary-precision integer.
 *
 * Replaces java.math.BigInteger so the Java port uses no library for
 * LargeInteger arithmetic (Python / Ruby / JS have big integers built into
 * the language itself, like Pharo's LargeInteger).
 *
 * Magnitude is stored little-endian in base 2^32 (int words read as unsigned).
 * Only the operations ZagBench needs are provided: valueOf, add, mod.
 */
public final class BeLargeInteger {

    private static final long MASK = 0xFFFFFFFFL;

    public static final BeLargeInteger ZERO = new BeLargeInteger(new int[0], 0);
    public static final BeLargeInteger ONE  = new BeLargeInteger(new int[]{1}, 1);

    private final int[] words;   // little-endian base-2^32 digits
    private final int   length;  // number of significant words

    private BeLargeInteger(int[] words, int length) {
        this.words  = words;
        this.length = length;
    }

    /** Create from a non-negative long. */
    public static BeLargeInteger valueOf(long v) {
        if (v == 0L) return ZERO;
        int hi = (int) (v >>> 32);
        if (hi == 0) return new BeLargeInteger(new int[]{(int) v}, 1);
        return new BeLargeInteger(new int[]{(int) v, hi}, 2);
    }

    /** Return this + other as a new BeLargeInteger (schoolbook addition with carry). */
    public BeLargeInteger add(BeLargeInteger other) {
        BeLargeInteger big   = (length >= other.length) ? this  : other;
        BeLargeInteger small = (big == this)            ? other : this;
        int[] r     = new int[big.length + 1];
        long  carry = 0L;
        int   i     = 0;
        for (; i < small.length; i++) {
            long s = (big.words[i] & MASK) + (small.words[i] & MASK) + carry;
            r[i]  = (int) s;
            carry = s >>> 32;
        }
        for (; i < big.length; i++) {
            long s = (big.words[i] & MASK) + carry;
            r[i]  = (int) s;
            carry = s >>> 32;
        }
        int len = big.length;
        if (carry != 0L) r[len++] = (int) carry;
        return new BeLargeInteger(r, len);
    }

    /** Remainder modulo a small positive int (used for cross-language result checks). */
    public int mod(int m) {
        long rem = 0L;
        for (int i = length - 1; i >= 0; i--) {
            rem = ((rem << 32) | (words[i] & MASK)) % m;
        }
        return (int) rem;
    }
}
