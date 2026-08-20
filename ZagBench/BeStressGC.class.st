Class {
	#name : 'BeStressGC',
	#superclass : 'Benchmark',
	#instVars : [
		'tree',
		'maxChildren',
		'seconds',
		'nodeCount'
	],
	#category : 'ZagBench-RandomTrees',
	#package : 'ZagBench',
	#tag : 'RandomTrees'
}

{ #category : 'benchmarking' }
BeStressGC >> benchmark: iterations [
	"Build a tree of iterations nodes, cut half, then GC.
     Returns live node count after cut — used by verifyResult:."

	"Chop iterations random subtrees from the tree.
     Rebuilds a fresh tree if the current one runs out of nodes."

	| chopCount |
	chopCount := 0.
	tree ifNil: [ self prepareTree ].
	tree liveNodes < 2 ifTrue: [ self prepareTree ].

	1 to: iterations do: [ :i |
			tree liveNodes > 1
				ifTrue: [
						tree cutRandomSubtree.
						chopCount := chopCount + 1 ]
				ifFalse: [ self prepareTree ] ].
	tree cutHalfSubtrees.
	tree garbageCollectMost.

	^ chopCount
]

{ #category : 'as yet unclassified' }
BeStressGC >> buildStats: results [
    "Build a stats dictionary from a collection of ms values."
    | total min max mean |
    results isEmpty ifTrue: [
        ^ Dictionary new
            at: #runs put: 0;
            at: #totalMs put: 0;
            at: #minMs put: 0;
            at: #maxMs put: 0;
            at: #meanMs put: 0;
            yourself].
    total := results inject: 0 into: [:sum :each | sum + each].
    min := results inject: results first into: [:m :each | m min: each].
    max := results inject: results first into: [:m :each | m max: each].
    mean := total / results size.
    ^ Dictionary new
        at: #runs put: results size;
        at: #totalMs put: total;
        at: #minMs put: min;
        at: #maxMs put: max;
        at: #meanMs put: mean;
        yourself
]

{ #category : 'initialization' }
BeStressGC >> initialize [

	super initialize.
	maxChildren := 4.
	nodeCount := 20000.
	tree := 0
]

{ #category : 'running' }
BeStressGC >> innerBenchmarkLoop: iterations [

	Smalltalk garbageCollectMost.
	self benchmark: iterations.
	^ true
]

{ #category : 'as yet unclassified' }
BeStressGC >> maxChildren: anInteger [
	maxChildren := anInteger
]

{ #category : 'accessing' }
BeStressGC >> nodeCount: anInteger [
	nodeCount := anInteger
]

{ #category : 'running' }
BeStressGC >> prepareTree [
    "Build the tree once before benchmarking the chop."
    tree := BeRandomTrees new
        nodeCount: nodeCount;
        maxChildren: maxChildren;
        build
]

{ #category : 'printing' }
BeStressGC >> printStats: stats label: label [
	"Print a statistics dictionary to Transcript."

	Transcript
		show: 'Runs      : ' , (stats at: #runs) printString;
		show: String lf;
		show: 'Total ms  : ' , (stats at: #totalMs) printString , String lf;
		show: 'Min ms    : ' , (stats at: #minMs) printString , String lf;
		show: 'Max ms    : ' , (stats at: #maxMs) printString , String lf;
		show: 'Mean ms   : ' , (stats at: #meanMs) printString , String lf;
		show: String lf
]

{ #category : 'as yet unclassified' }
BeStressGC >> run: innerIterations [ 
    "Run innerBenchmarkLoop: repeatedly until seconds have elapsed.
     Returns a Dictionary with statistics."
    | results startTime elapsed ms |
    results := OrderedCollection new.
    startTime := DateAndTime now.
    
    [
        elapsed := (DateAndTime now - startTime) totalSeconds.
        elapsed < seconds
    ] whileTrue: [
        ms := Time millisecondsToRun: [
            self innerBenchmarkLoop: innerIterations].
        results add: ms.
    ].
    
    ^ self statisticsFrom: results
]

{ #category : 'as yet unclassified' }
BeStressGC >> run: innerIterations forSeconds: seconds [
    "Run innerBenchmarkLoop: repeatedly until seconds have elapsed.
     Returns a Dictionary with statistics."
    | results startTime elapsed ms |
    results := OrderedCollection new.
    startTime := DateAndTime now.
    
    [
        elapsed := (DateAndTime now - startTime) totalSeconds.
        elapsed < seconds
    ] whileTrue: [
        ms := Time millisecondsToRun: [
            self innerBenchmarkLoop: innerIterations].
        results add: ms.
    ].
    
    ^ self statisticsFrom: results
]

{ #category : 'as yet unclassified' }
BeStressGC >> runIterations: innerIterations [
	"Run innerBenchmarkLoop: repeatedly until seconds elapse.
     Call seconds: first to set duration. Default is 0.4 seconds."

	| results startTime elapsed ms valid |
	results := OrderedCollection new.
	startTime := DateAndTime now.
	[
		elapsed := (DateAndTime now - startTime) totalSeconds.
		elapsed < seconds ] whileTrue: [
			ms := Time millisecondsToRun: [ valid := self innerBenchmarkLoop: innerIterations ].
			valid ifFalse: [ ].
			results add: ms ].
	^ self buildStats: results
]

{ #category : 'instance creation' }
BeStressGC >> seconds: afraction [
seconds := afraction .
]

{ #category : 'as yet unclassified' }
BeStressGC >> statisticsFrom: results [
    "Compute min, max, mean, total from a collection of ms timings."
    | total min max mean |
    results isEmpty ifTrue: [^ Dictionary new].
    total := results inject: 0 into: [:sum :each | sum + each].
    min := results inject: results first into: [:m :each | m min: each].
    max := results inject: results first into: [:m :each | m max: each].
    mean := total / results size.
    ^ Dictionary new
        at: #runs put: results size;
        at: #totalMs put: total;
        at: #minMs put: min;
        at: #maxMs put: max;
        at: #meanMs put: mean;
        at: #results put: results;
        yourself
]
