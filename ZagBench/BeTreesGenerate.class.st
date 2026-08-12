Class {
	#name : 'BeTreesGenerate',
	#superclass : 'Object',
	#category : 'ZagBench-Benchmarking',
	#package : 'ZagBench',
	#tag : 'Benchmarking'
}

{ #category : 'benchmarking' }
BeTreesGenerate >> benchmark [
    "Subclasses override this to run one unit of work.
     Returns a result that verify: can check."
    ^ self subclassResponsibility
]

{ #category : 'benchmarking' }
BeTreesGenerate >> benchmark: innerIterations [
    "Subclasses override if they need innerIterations passed in."
    ^ self benchmark
]

{ #category : 'as yet unclassified' }
BeTreesGenerate >> buildStats: results [
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

{ #category : 'running' }
BeTreesGenerate >> innerBenchmarkLoop: innerIterations [
    "Run benchmark innerIterations times and verify each result."
    ^ self verifyResult: (self benchmark: innerIterations)
]

{ #category : 'accessing' }
BeTreesGenerate >> maxChildren: anInteger [
    | maxChildren |
maxChildren := anInteger
]

{ #category : 'printing' }
BeTreesGenerate >> printStats: stats label: label [
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
BeTreesGenerate >> run: innerIterations forSeconds: seconds [
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
BeTreesGenerate >> runIterations: innerIterations [
	"Run innerBenchmarkLoop: repeatedly until seconds elapse.
     Call seconds: first to set duration. Default is 0.4 seconds."

	| results startTime elapsed ms valid seconds|
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
BeTreesGenerate >> seconds: afraction [
|seconds|
seconds := afraction .
]

{ #category : 'as yet unclassified' }
BeTreesGenerate >> statisticsFrom: results [
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

{ #category : 'as yet unclassified' }
BeTreesGenerate >> verifyResult: result [
    "Subclasses override to validate the result of benchmark."
    ^ self subclassResponsibility
]
