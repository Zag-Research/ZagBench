Class {
	#name : 'RandomTrees',
	#superclass : 'TestCase',
	#instVars : [
		'children'
	],
	#classInstVars : [
		'andomTreesTest',
		'randomTreesTest'
	],
	#category : 'ZagBench-Test',
	#package : 'ZagBench',
	#tag : 'Test'
}

{ #category : 'as yet unclassified' }
RandomTrees >> randomTreesTest [
 |tree |
tree := BeRandomTrees new
    nodeCount: 5000;
    maxChildren: 4;
    build.

tree printSummary.

tree cutRandomSubtree.
tree printSummary.

tree cutHalfSubtrees.
tree printSummary.

tree garbageCollect.
tree garbageCollectMost .
]
