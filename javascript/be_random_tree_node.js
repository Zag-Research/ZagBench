// ZagBench – BeRandomTreeNode (JavaScript port of BeRandomTreeNode.class.st).
//
// Tree node used by BeStressGC.  Iterative DFS for allNodes().
'use strict';

class BeRandomTreeNode {
  constructor() {
    this.value    = 0;
    this.parent   = null;
    this.children = [];
  }

  addChild(node) {
    node.parent = this;
    this.children.push(node);
  }

  // Approximate Pharo's liveNodes: direct children + self
  liveNodes() { return this.children.length + 1; }

  // Iterative DFS – avoids call stack overflow on large trees
  allNodes() {
    const result = [];
    const stack  = [this];
    while (stack.length > 0) {
      const node = stack.pop();
      result.push(node);
      for (let i = node.children.length - 1; i >= 0; i--) stack.push(node.children[i]);
    }
    return result;
  }

  // Remove the first half of direct children (Pharo cutHalfSubtrees)
  cutHalfSubtrees() {
    const half    = Math.trunc(this.children.length / 2);
    const victims = new Array(half);
    for (let i = 0; i < half; i++) victims[i] = this.children[i];
    for (let i = 0; i < half; i++) this._removeChild(victims[i]);
    return this;
  }

  // Remove a randomly chosen non-root node (Pharo cutRandomSubtree:)
  cutRandomSubtree(random) {
    const all = this.allNodes();
    if (all.length <= 1) return this;
    // Skip root (index 0); nextInteger returns 1-based in [1, n-1]
    const idx  = random.nextInteger(all.length - 1);  // 1-based
    const pick = all[idx];                              // indices 1..(n-1)
    if (pick.parent !== null) pick.parent._removeChild(pick);
    return this;
  }

  // Scan for node, shift later children left (like Java's removeChildAt)
  _removeChild(node) {
    const children = this.children;
    const n = children.length;
    for (let i = 0; i < n; i++) {
      if (children[i] === node) {
        for (let j = i; j < n - 1; j++) children[j] = children[j + 1];
        children.pop();
        return;
      }
    }
  }
}

module.exports = { BeRandomTreeNode };
