Class {
	#name : 'BenchmarkTreeGrow',
	#superclass : 'Benchmark',
	#instVars : [
		'maxChildren',
		'seconds'
	],
	#category : 'ZagBench-RandomTrees',
	#package : 'ZagBench',
	#tag : 'RandomTrees'
}

{ #category : 'as yet unclassified' }
BenchmarkTreeGrow >> benchmark [
	^ self shouldBeImplemented
]

{ #category : 'benchmarking' }
BenchmarkTreeGrow >> benchmark: innerIterations [
    "Build a fresh tree of innerIterations nodes.
     Returns the live node count."
    |tree |
    tree := BeRandomTreeNode new
        nodeCount: innerIterations;
        maxChildren: maxChildren;
        build.
    ^ tree liveNodes size
]

{ #category : 'initialization' }
BenchmarkTreeGrow >> initialize [
    super initialize.
    maxChildren := 4
]

{ #category : 'running' }
BenchmarkTreeGrow >> innerBenchmarkLoop: innerIterations [
    ^ self verifyResult: (self benchmark: innerIterations)
]

{ #category : 'accessing' }
BenchmarkTreeGrow >> maxChildren: anInteger [
maxChildren := anInteger
]

{ #category : 'instance creation' }
BenchmarkTreeGrow >> seconds: aFraction [

	seconds := aFraction
]

{ #category : 'as yet unclassified' }
BenchmarkTreeGrow >> verifyResult: result [

	result isInteger ifFalse: [ ^ false ].
	result > 0 ifFalse: [ ^ false ].
	^ true
]
