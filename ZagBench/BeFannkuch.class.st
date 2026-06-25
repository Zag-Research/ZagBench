"
I implement the Fannkuch benchmarks

Heavy test of array operations
"
Class {
	#name : 'BeFannkuch',
	#superclass : 'Benchmark',
	#category : 'ZagBench-Fannkuch',
	#package : 'ZagBench',
	#tag : 'Fannkuch'
}

{ #category : 'benchmarking' }
BeFannkuch class >> innerIterations [

	^ 9
]

{ #category : 'benchmarking' }
BeFannkuch class >> mainIterations [

	^ 32
]

{ #category : 'running' }
BeFannkuch >> innerBenchmarkLoop: iterations [

	^ self verify: (self solve: iterations) for: iterations
]

{ #category : 'benchmarking' }
BeFannkuch >> solve: n [

"(BeFannkuch new solve: 10) >>> #( 73196 38 )"

	| maxCount checkSum flips toFlip permCount array |
	maxCount := 0.
	checkSum := 0.
	permCount := 0.
	(1 to: n) permutationsIteratedDo: [ :permutation |
			permutation first ~= 1 ifTrue: [
					array := permutation copy.
					flips := 0.
					[ (toFlip := array at: 1) = 1 ] whileFalse: [
							flips := flips + 1.
							1 to: toFlip // 2 do: [ :i |
									| temp target |
									target := toFlip - i + 1.
									temp := array at: i.
									array at: i put: (array at: target).
									array at: target put: temp ] ].
					maxCount := maxCount max: flips.
					checkSum := checkSum + (permCount even
						             ifTrue: [ flips ]
						             ifFalse: [ flips negated ]) ].
			permCount := permCount + 1 ].
	^ {
		  checkSum.
		  maxCount }
]

{ #category : 'benchmarking' }
BeFannkuch >> verify: result for: iterations [

	iterations = 1 ifTrue: [ ^ result = #( 0 0 ) ].
	iterations = 2 ifTrue: [ ^ result = #( -1 1 ) ].
	iterations = 3 ifTrue: [ ^ result = #( 2 2 ) ].
	iterations = 4 ifTrue: [ ^ result = #( 4 4 ) ].
	iterations = 5 ifTrue: [ ^ result = #( 11 7 ) ].
	iterations = 6 ifTrue: [ ^ result = #( 49 10 ) ].
	iterations = 7 ifTrue: [ ^ result = #( 228 16 ) ].
	iterations = 8 ifTrue: [ ^ result = #( 1616 22 ) ].
	iterations = 9 ifTrue: [ ^ result = #( 8629 30 ) ].
	iterations = 10 ifTrue: [ ^ result = #( 73196 38 ) ].
	iterations = 11 ifTrue: [ ^ result = #(556355 51) ].

	ScriptConsole << 'No verification result for ' << iterations asString.
	^ false
]
