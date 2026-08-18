Class {
	#name : 'BenchmarkRandomTrees',
	#superclass : 'BeTreesGenerate',
	#instVars : [
		'tree',
		'maxChildren'
	],
	#category : 'ZagBench-Benchmarking',
	#package : 'ZagBench',
	#tag : 'Benchmarking'
}

{ #category : 'benchmarking' }
BenchmarkRandomTrees >> benchmark: innerIterations [
    "Build a tree of innerIterations nodes, cut half, then GC.
     Returns live node count after cut — used by verifyResult:."
    tree := BeRandomTrees new
        nodeCount: innerIterations;
        maxChildren: maxChildren;
        build.
    tree cutHalfSubtrees.
    tree garbageCollectMost .
    ^ tree liveNodes size
]

{ #category : 'initialization' }
BenchmarkRandomTrees >> initialize [
    super initialize.
    maxChildren := 4.
 		seconds := 0.4.
    		tree := 0.
]

{ #category : 'running' }
BenchmarkRandomTrees >> innerBenchmarkLoop: innerIterations [
    "One full loop: build tree, cut nodes, collect garbage, verify."
    ^ self verifyResult: (self benchmark: innerIterations)
]

{ #category : 'accessing' }
BenchmarkRandomTrees >> maxChildren: anInteger [
    maxChildren := anInteger
]

{ #category : 'accessing' }
BenchmarkRandomTrees >> seconds: aFraction [
seconds := aFraction 
]

{ #category : 'as yet unclassified' }
BenchmarkRandomTrees >> verifyResult: result [
	"We cannot predict exact live count after random cuts,
     so we verify the result is a plausible non-zero integer."

	result isInteger ifFalse: [ ^ false ].
	result > 0 ifFalse: [ ^ false ].
	^ true
]
