"
I am based on the benchmark in the [Design, implementation, and evaluation of the Resilient Smalltalk embedded platform](https://www.sciencedirect.com/science/article/abs/pii/S1477842405000060) that stresses block creation and non-local return.
"
Class {
	#name : 'BeResilientBlocks',
	#superclass : 'Benchmark',
	#category : 'ZagBench-ResilientBlocks',
	#package : 'ZagBench',
	#tag : 'ResilientBlocks'
}

{ #category : 'benchmarking' }
BeResilientBlocks class >> innerIterations [

	^ 2500
]

{ #category : 'benchmarking' }
BeResilientBlocks class >> mainIterations [

	^ 15
]

{ #category : 'running' }
BeResilientBlocks >> evaluate: iterations [

	| sum size |
	sum := 0.
	size := 1.
	[ size < iterations ] whileTrue: [
		sum := sum + (BeResilientList new: size) size.
		size := size + 1 ].
	^ sum
]

{ #category : 'running' }
BeResilientBlocks >> innerBenchmarkLoop: iterations [

	^ self
		  verify: (self evaluate: iterations)
		  inner: iterations
]

{ #category : 'verification' }
BeResilientBlocks >> verify: result inner: iterations [

	iterations = 2500 ifTrue: [ ^ result = 3123750 ].

	ScriptConsole
		<< 'No verification result for ';
		<< iterations asString;
		<< ' found';
		cr.
	ScriptConsole
		<< 'Result is: ';
		<< result asString;
		cr.
	^ false
]
