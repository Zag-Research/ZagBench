Class {
	#name : 'BenchmarkRandomTrees',
	#superclass : 'BeTreesGenerate',
	#category : 'ZagBench-RandomTrees',
	#package : 'ZagBench',
	#tag : 'RandomTrees'
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
