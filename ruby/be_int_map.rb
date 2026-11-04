# ZagBench – BeIntMap: hand-rolled hash map from int keys to object values.
#
# Open addressing with linear probing, power-of-two capacity (starts at 8),
# grows x2 when it would exceed 50% load. The same algorithm is used in the
# Java, Python and JavaScript ports, so every language runs identical
# dictionary code (no Hash).

class BeIntMap
  def initialize
    @keys   = Array.new(8, 0)
    @values = Array.new(8, nil)
    @used   = Array.new(8, false)
    @count  = 0
  end

  # Fibonacci hashing (32-bit, same bits as the Java port).
  def self.slot(key, mask)
    h = (key * 0x9E3779B1) & 0xFFFFFFFF
    (h ^ (h >> 16)) & mask
  end

  # Return the value stored for key, or nil if absent.
  def get(key)
    keys = @keys
    used = @used
    mask = keys.length - 1
    i    = BeIntMap.slot(key, mask)
    while used[i]
      return @values[i] if keys[i] == key
      i = (i + 1) & mask
    end
    nil
  end

  # Store value for key (replacing any existing value).
  def put(key, value)
    _grow if (@count + 1) * 2 > @keys.length
    keys = @keys
    used = @used
    mask = keys.length - 1
    i    = BeIntMap.slot(key, mask)
    while used[i]
      if keys[i] == key
        @values[i] = value
        return
      end
      i = (i + 1) & mask
    end
    used[i]    = true
    keys[i]    = key
    @values[i] = value
    @count    += 1
  end

  def size = @count

  private

  def _grow
    old_keys   = @keys
    old_values = @values
    old_used   = @used
    cap        = old_keys.length * 2
    mask       = cap - 1
    keys   = Array.new(cap, 0)
    values = Array.new(cap, nil)
    used   = Array.new(cap, false)
    i = 0
    while i < old_keys.length
      if old_used[i]
        j = BeIntMap.slot(old_keys[i], mask)
        j = (j + 1) & mask while used[j]
        used[j]   = true
        keys[j]   = old_keys[i]
        values[j] = old_values[i]
      end
      i += 1
    end
    @keys   = keys
    @values = values
    @used   = used
  end
end
