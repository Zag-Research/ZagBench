Class {
	#name : 'BeStressGC',
	#superclass : 'Benchmark',
	#instVars : [
		'tree',
		'maxChildren',
		'seconds',
		'nodeCount'
	],
	#category : 'ZagBench-StressGC',
	#package : 'ZagBench',
	#tag : 'StressGC'
}

{ #category : 'benchmarking' }
BeStressGC class >> innerIterations [

	^ 10000
]

{ #category : 'benchmarking' }
BeStressGC >> benchmark: iterations [
	"Chop iterations random subtrees from the tree, then cut half the remaining
     top-level subtrees and run a partial GC. Rebuilds a fresh tree if the
     current one runs out of nodes. Returns the number of subtrees chopped."

	| chopCount |
	chopCount := 0.
	self build.
	1 to: iterations do: [ :i |
			tree liveNodes > 1
				ifTrue: [
						i odd
							ifTrue: [ tree cutHalfSubtrees ]
							ifFalse: [ tree cutRandomSubtree: random ].
						chopCount := chopCount + 1 ]
				ifFalse: [ self build ] ].
	^ chopCount
]

{ #category : 'building' }
BeStressGC >> build [

	| queue current childCount child created |
	tree := self nodeClass new.
	tree value: 0.
	queue := OrderedCollection new.
	queue addLast: tree.
	created := 1.
	[ created < nodeCount and: [ queue notEmpty ] ] whileTrue: [
			current := queue removeFirst.
			childCount := 1 + (random nextInteger: maxChildren).
			1 to: childCount do: [ :i |
					created < nodeCount ifTrue: [
							child := self nodeClass new.
							child value: created.
							current addChild: child.
							queue addLast: child.
							created := created + 1 ] ] ].

	^ self
]

{ #category : 'memory space' }
BeStressGC >> garbageCollect [
	"Primitive. Reclaims all garbage and answers the size of the largest free chunk in old space."

	Smalltalk garbageCollect

]

{ #category : 'memory space' }
BeStressGC >> garbageCollectMost [
	"Primitive. Reclaims recently created garbage (which is usually most of it) fairly quickly and answers the number of bytes of available space."

	Smalltalk garbageCollectMost

]

{ #category : 'initialization' }
BeStressGC >> initialize [

	super initialize.
	self nodeCount: 1000.
	self maxChildren: 4.
	random := BeRandom new
]

{ #category : 'running' }
BeStressGC >> innerBenchmarkLoop: iterations [ 
    Smalltalk garbageCollectMost.
    self benchmark: iterations.
    ^ true
]

{ #category : 'accessing' }
BeStressGC >> maxChildren: anInteger [ 
    maxChildren := anInteger
]

{ #category : 'configuration' }
BeStressGC >> nodeClass [
	^ BeRandomTreeNode 
]

{ #category : 'accessing' }
BeStressGC >> nodeCount: anInteger [

	nodeCount := anInteger
]
