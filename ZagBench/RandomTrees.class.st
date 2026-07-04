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

{ #category : 'printing' }
RandomTrees >> printAll [

	| tree ms |
	Transcript
		open;
		clear.

	#( 20000 40000 80000 ) do: [ :n |
			#( 4 8 ) do: [ :c | "Build fresh tree — outside timer so tree binding is clean"
					tree := BeRandomTrees new
						        nodeCount: n;
						        maxChildren: c.

					ms := Time millisecondsToRun: [ tree build ].
					Transcript show:
						'=== nodes: ' , n printString , ' | maxChildren: '
						, c printString , ' ===' , String lf.
					Transcript show:
						'Build time       : ' , ms printString , ' ms' , String lf.
					Transcript show:
						'Live nodes       : ' , tree liveNodes size printString
						, String lf.

					"Time cutRandomSubtree"
					ms := Time millisecondsToRun: [ tree cutRandomSubtree ].
					Transcript show:
						'cutRandomSubtree : ' , ms printString , ' ms' , String lf.
					Transcript show:
						'Live after cut   : ' , tree liveNodes size printString
						, String lf.

					"Time cutHalfSubtrees"
					ms := Time millisecondsToRun: [ tree cutHalfSubtrees ].
					Transcript show:
						'cutHalfSubtrees  : ' , ms printString , ' ms' , String lf.
					Transcript show:
						'Live after half  : ' , tree liveNodes size printString
						, String lf.

					"Time minor GC"
					ms := Time millisecondsToRun: [ tree garbageCollect ].
					Transcript show:
						'Minor GC         : ' , ms printString , ' ms' , String lf.

					"Time full GC"
					ms := Time millisecondsToRun: [ tree garbageCollectMost ].
					Transcript
						show: 'Full GC          : ' , ms printString , ' ms';
						show: String lf ] ]
]

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
