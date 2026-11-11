// ZagBench – BeDataFrame (JavaScript port of BeDataFrame.class.st).
//
// Benchmarks hand-rolled CSV parsing of mnist_test.csv.
// File I/O uses Node's built-in 'fs' module (infrastructure, not algorithm).
// CSV tokeniser and row/column storage are entirely hand-rolled.
//
// Verifies: numberOfColumns == 785 and numberOfRows == innerIterations.
// Run from the directory containing mnist_test.csv.
'use strict';

const fs = require('fs');

const { Benchmark } = require('./benchmark');

// Hand-rolled synchronous buffered line reader (Node has no sync readLine).
// 8 KB chunks, like java.io.BufferedReader's default buffer.
// Bytes map 1:1 to chars ('latin1'), which is exact for the ASCII mnist file.
class LineReader {
  constructor(fd) {
    this._fd      = fd;
    this._buf     = Buffer.alloc(8192);
    this._pending = '';
    this._pos     = 0;
    this._eof     = false;
  }

  // Returns the next line without its '\n' / '\r\n', or null at end of file.
  readLine() {
    let scan = this._pos;
    for (;;) {
      const s = this._pending;
      for (let i = scan; i < s.length; i++) {
        if (s[i] === '\n') {
          const end  = (i > this._pos && s[i - 1] === '\r') ? i - 1 : i;
          const line = s.slice(this._pos, end);
          this._pos  = i + 1;
          return line;
        }
      }
      if (this._eof) {
        if (this._pos >= s.length) return null;
        const line = s.slice(this._pos);
        this._pos = s.length;
        return line;
      }
      const n = fs.readSync(this._fd, this._buf, 0, this._buf.length, null);
      const rest = s.slice(this._pos);
      scan = rest.length;
      this._pos = 0;
      if (n === 0) {
        this._eof     = true;
        this._pending = rest;
      } else {
        this._pending = rest + this._buf.toString('latin1', 0, n);
      }
    }
  }
}

class BeDataFrame extends Benchmark {
  static get mainIterations()  { return 10; }
  static get innerIterations() { return 500; }

  constructor() {
    super();
    this._columnNames = [];
    this._rows        = [];
  }

  get numberOfColumns() { return this._columnNames.length; }
  get numberOfRows()    { return this._rows.length; }

  innerBenchmarkLoop(innerIterations) {
    this._loadDataFrame(innerIterations);
    return this._verify(innerIterations);
  }

  // -------------------------------------------------------------------------
  // Hand-rolled CSV parser
  // -------------------------------------------------------------------------

  _isTrimmable(ch) {
    return ch === ' ' || ch === '\t' || ch === '\r' || ch === '\n';
  }

  _trimToken(s) {
    let start = 0, stop = s.length - 1;
    while (start <= stop && this._isTrimmable(s[start]))  start++;
    while (stop >= start && this._isTrimmable(s[stop]))   stop--;
    return start > stop ? '' : s.slice(start, stop + 1);
  }

  _splitCSVLine(line) {
    const tokens = [];
    let start = 0;
    for (let i = 0; i < line.length; i++) {
      if (line[i] === ',') {
        tokens.push(this._trimToken(line.slice(start, i)));
        start = i + 1;
      }
    }
    tokens.push(this._trimToken(line.slice(start)));
    return tokens;
  }

  // -------------------------------------------------------------------------
  // Data loading
  // -------------------------------------------------------------------------

  // Streams line by line and stops after header + innerIterations rows,
  // matching the Java (BufferedReader) and Ruby (File#gets) ports.
  _loadDataFrame(innerIterations) {
    let fd;
    try {
      fd = fs.openSync('mnist_test.csv', 'r');
    } catch (e) {
      throw new Error('Cannot read mnist_test.csv. Run DataFrame from the folder that contains mnist_test.csv.');
    }
    try {
      const reader = new LineReader(fd);
      // Header
      this._columnNames = this._splitCSVLine(reader.readLine());

      // Data rows
      this._rows = [];
      let line;
      while (this._rows.length < innerIterations && (line = reader.readLine()) !== null) {
        this._rows.push(this._splitCSVLine(line));
      }
    } finally {
      fs.closeSync(fd);
    }
  }

  // -------------------------------------------------------------------------

  _verify(innerIterations) {
    if (this._rows.length !== innerIterations) {
      process.stdout.write(`Row count mismatch: got ${this._rows.length} expected ${innerIterations}\n`);
      return false;
    }
    if (this._columnNames.length !== 785) {
      process.stdout.write(`Column count mismatch: got ${this._columnNames.length} expected 785\n`);
      return false;
    }
    return true;
  }
}

module.exports = { BeDataFrame };
