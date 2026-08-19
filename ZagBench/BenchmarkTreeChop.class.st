Class {
	#name : 'BenchmarkTreeChop',
	#superclass : 'Benchmark',
	#instVars : [
		'nodeCount',
		'maxChildren',
		'seconds',
		'tree'
	],
	#category : 'ZagBench-RandomTrees',
	#package : 'ZagBench',
	#tag : 'RandomTrees'
}

{ #category : 'as yet unclassified' }
BenchmarkTreeChop >> benchmark [
	^ self shouldBeImplemented
]

{ #category : 'benchmarking' }
BenchmarkTreeChop >> benchmark: innerIterations [
    "Chop innerIterations random subtrees from the tree.
     Rebuilds a fresh tree if the current one runs out of nodes."
    | chopCount |
    chopCount := 0.
    tree ifNil: [self prepareTree].
    tree liveNodes size < 2 ifTrue: [self prepareTree].

    1 to: innerIterations do: [:i |
        tree liveNodes size > 1
            ifTrue: [
                tree cutRandomSubtree.
                chopCount := chopCount + 1]
            ifFalse: [self prepareTree]].
    ^ chopCount
]

{ #category : 'initialization' }
BenchmarkTreeChop >> initialize [

    super initialize.
    nodeCount := 20000.
    maxChildren := 4.
    tree := 0.
]

{ #category : 'running' }
BenchmarkTreeChop >> innerBenchmarkLoop: innerIterations [
    ^ self verifyResult: (self benchmark: innerIterations)
]

{ #category : 'accessing' }
BenchmarkTreeChop >> maxChildren: anInteger [
maxChildren := anInteger
]

{ #category : 'accessing' }
BenchmarkTreeChop >> nodeCount: anInteger [
nodeCount := anInteger
]

{ #category : 'as yet unclassified' }
BenchmarkTreeChop >> prepareTree [
    "Build the tree once before benchmarking the chop."
    tree := BeRandomTrees new
        nodeCount: nodeCount;
        maxChildren: maxChildren;
        build
]

{ #category : 'instance creation' }
BenchmarkTreeChop >> seconds: aFraction [
seconds := aFraction 
]

{ #category : 'as yet unclassified' }
BenchmarkTreeChop >> verifyResult: result [
	"Verify that the number of chops equals innerIterations
     or is at least 1 (some rebuilds may have happened)."

	result isInteger ifFalse: [ ^ false ].
	result > 0 ifFalse: [ ^ false ].
	^ true
]
