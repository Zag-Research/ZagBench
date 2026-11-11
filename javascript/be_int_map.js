// ZagBench – BeIntMap: hand-rolled hash map from int keys to object values.
//
// Open addressing with linear probing, power-of-two capacity (starts at 8),
// grows x2 when it would exceed 50% load. The same algorithm is used in the
// Java, Python and Ruby ports, so every language runs identical
// dictionary code (no Map / object-as-dict).
'use strict';

function newFilled(n, v) {
  const a = new Array(n);
  for (let i = 0; i < n; i++) a[i] = v;
  return a;
}

// Fibonacci hashing (32-bit, same bits as the Java port). key * 0x9E3779B1
// stays below 2^53 for ZagBench keys (<= 200000), so the product is exact
// and '>>> 0' takes it modulo 2^32.
function slot(key, mask) {
  const h = (key * 0x9E3779B1) >>> 0;
  return (h ^ (h >>> 16)) & mask;
}

class BeIntMap {
  constructor() {
    this._keys   = newFilled(8, 0);
    this._values = newFilled(8, null);
    this._used   = newFilled(8, false);
    this._count  = 0;
  }

  // Return the value stored for key, or null if absent.
  get(key) {
    const keys = this._keys, used = this._used;
    const mask = keys.length - 1;
    let i = slot(key, mask);
    while (used[i]) {
      if (keys[i] === key) return this._values[i];
      i = (i + 1) & mask;
    }
    return null;
  }

  // Store value for key (replacing any existing value).
  put(key, value) {
    if ((this._count + 1) * 2 > this._keys.length) this._grow();
    const keys = this._keys, used = this._used;
    const mask = keys.length - 1;
    let i = slot(key, mask);
    while (used[i]) {
      if (keys[i] === key) { this._values[i] = value; return; }
      i = (i + 1) & mask;
    }
    used[i] = true; keys[i] = key; this._values[i] = value; this._count++;
  }

  size() { return this._count; }

  _grow() {
    const oldKeys = this._keys, oldValues = this._values, oldUsed = this._used;
    const cap  = oldKeys.length * 2;
    const mask = cap - 1;
    const keys = newFilled(cap, 0), values = newFilled(cap, null), used = newFilled(cap, false);
    for (let i = 0; i < oldKeys.length; i++) {
      if (oldUsed[i]) {
        let j = slot(oldKeys[i], mask);
        while (used[j]) j = (j + 1) & mask;
        used[j] = true; keys[j] = oldKeys[i]; values[j] = oldValues[i];
      }
    }
    this._keys = keys; this._values = values; this._used = used;
  }
}

module.exports = { BeIntMap };
