// ZagBench – BeResilientList (JavaScript port of BeResilientList.class.st).
//
// Immutable singly-linked list node; iterative build to avoid stack overflow.
'use strict';

class BeResilientList {
  constructor(nextNode) {
    this._nextNode = nextNode;
  }

  static build(size) {
    let head = null;
    for (let i = 0; i < size; i++) head = new BeResilientList(head);
    return head;
  }

  size() {
    let count = 0;
    let node  = this;
    while (node !== null) {
      count++;
      node = node._nextNode;
    }
    return count;
  }
}

module.exports = { BeResilientList };
