// ZagBench – BeStressGC (JavaScript port of BeStressGC.class.st).
//
// Stresses the GC by building a random tree and repeatedly chopping it.
// Verifies the chop count for the default 10000 iterations (9901).
'use strict';

const { Benchmark }       = require('./benchmark');
const { BeRandom }        = require('./be_random');
const { BeRandomTreeNode} = require('./be_random_tree_node');

const NODE_COUNT   = 1000;
const MAX_CHILDREN = 4;

class BeStressGC extends Benchmark {
  static get mainIterations()  { return 10; }
  static get innerIterations() { return 10000; }

  constructor() {
    super();
    this._random = new BeRandom();
    this._tree   = null;
  }

  innerBenchmarkLoop(innerIterations) {
    const chops = this._benchmark(innerIterations);
    // Known result for the default count (same in every port); others are not checked
    if (innerIterations === 10000 && chops !== 9901) {
      process.stdout.write(`StressGC chop count mismatch: got ${chops} expected 9901\n`);
      return false;
    }
    return true;
  }

  _benchmark(iterations) {
    let chopCount = 0;
    this._build();
    for (let i = 1; i <= iterations; i++) {
      if (this._tree.liveNodes() > 1) {
        if (i % 2 === 1) this._tree.cutHalfSubtrees();
        else             this._tree.cutRandomSubtree(this._random);
        chopCount++;
      } else {
        this._build();
      }
    }
    return chopCount;
  }

  _build() {
    this._tree = new BeRandomTreeNode();
    this._tree.value = 0;

    // BFS using a plain array with a front-index pointer (O(1) dequeue)
    const queue = new Array(NODE_COUNT + 1);
    let qHead = 0, qTail = 0;
    queue[qTail++] = this._tree;

    let created = 1;
    while (created < NODE_COUNT && qHead < qTail) {
      const current    = queue[qHead++];
      const childCount = 1 + this._random.nextInteger(MAX_CHILDREN);
      for (let c = 0; c < childCount && created < NODE_COUNT; c++) {
        const child   = new BeRandomTreeNode();
        child.value   = created++;
        current.addChild(child);
        queue[qTail++] = child;
      }
    }
  }
}

module.exports = { BeStressGC };
