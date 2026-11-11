"""
ZagBench – BeIntMap: hand-rolled hash map from int keys to object values.

Open addressing with linear probing, power-of-two capacity (starts at 8),
grows x2 when it would exceed 50% load. The same algorithm is used in the
Java, JavaScript and Ruby ports, so every language runs identical
dictionary code (no dict).
"""


class BeIntMap:
    __slots__ = ("_keys", "_values", "_used", "_count")

    def __init__(self):
        self._keys   = [0] * 8
        self._values = [None] * 8
        self._used   = [False] * 8
        self._count  = 0

    @staticmethod
    def _slot(key, mask):
        """Fibonacci hashing (32-bit, same bits as the Java port)."""
        h = (key * 0x9E3779B1) & 0xFFFFFFFF
        return (h ^ (h >> 16)) & mask

    def get(self, key):
        """Return the value stored for key, or None if absent."""
        keys = self._keys
        used = self._used
        mask = len(keys) - 1
        i    = self._slot(key, mask)
        while used[i]:
            if keys[i] == key:
                return self._values[i]
            i = (i + 1) & mask
        return None

    def put(self, key, value):
        """Store value for key (replacing any existing value)."""
        if (self._count + 1) * 2 > len(self._keys):
            self._grow()
        keys = self._keys
        used = self._used
        mask = len(keys) - 1
        i    = self._slot(key, mask)
        while used[i]:
            if keys[i] == key:
                self._values[i] = value
                return
            i = (i + 1) & mask
        used[i] = True
        keys[i] = key
        self._values[i] = value
        self._count += 1

    def size(self):
        return self._count

    def _grow(self):
        old_keys   = self._keys
        old_values = self._values
        old_used   = self._used
        cap        = len(old_keys) * 2
        mask       = cap - 1
        keys   = [0] * cap
        values = [None] * cap
        used   = [False] * cap
        for i in range(len(old_keys)):
            if old_used[i]:
                j = self._slot(old_keys[i], mask)
                while used[j]:
                    j = (j + 1) & mask
                used[j]   = True
                keys[j]   = old_keys[i]
                values[j] = old_values[i]
        self._keys   = keys
        self._values = values
        self._used   = used
