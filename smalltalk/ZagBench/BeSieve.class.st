"
Classic Sieve of Eratosthenes banchmark

I test integer and array with a doubly-nested loop.

Derived from https://github.com/smarr/are-we-fast-yet/blob/master/benchmarks/Smalltalk/Sieve.som
"
Class {
	#name : 'BeSieve',
	#superclass : 'Benchmark',
	#category : 'ZagBench-Sieve',
	#package : 'ZagBench',
	#tag : 'Sieve'
}

{ #category : 'benchmarking' }
BeSieve class >> innerIterations [

	^ 12500000
]

{ #category : 'running' }
BeSieve >> innerBenchmarkLoop: iterations [

	^ self
		  verify: (self sieve: (Array new: iterations  withAll: true))
		  for: iterations
]

{ #category : 'accessing' }
BeSieve >> iterations [

	^ 10000
]

{ #category : 'benchmarking' }
BeSieve >> sieve: flags [
	| size primeCount |
	size := flags size.
	primeCount := 0.

	2 to: size do: [ :i |
		(flags at: i - 1) ifTrue: [
			| k |
			primeCount := primeCount + 1.
			k := i + i.
			[ k <= size ] whileTrue: [
				flags at: k - 1 put: false.
				k := k + i ]. ] ].
	^ primeCount
]

{ #category : 'benchmarking' }
BeSieve >> verify: result for: iterations [

	iterations = 12500000 ifTrue: [ ^ result = 818703 ].
	iterations = 10000000 ifTrue: [ ^ result = 664579 ].
	iterations =  1000000 ifTrue: [ ^ result = 78498 ].
	iterations =   250000 ifTrue: [ ^ result = 22044 ].
	iterations =    10000 ifTrue: [ ^ result = 1229 ].
	iterations =     5000 ifTrue: [ ^ result = 669 ].
	iterations =        1 ifTrue: [ ^ result = 0 ].

	ScriptConsole << 'No verification result for ' << iterations asString << ' found'; cr.
	ScriptConsole << 'Result is: ' << result asString; cr.
	^ false
]
