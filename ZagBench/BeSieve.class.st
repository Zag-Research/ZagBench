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
BeSieve >> benchmark [
    | flags |
    flags  := Array new: 5000 withAll: true.
    ^ self sieve: flags.

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
    iterations = 250000 ifTrue: [ ^ result = 22044 ].
    iterations =   5000 ifTrue: [ ^ result = 669 ].
    iterations =      1 ifTrue: [ ^ result = 0 ].

    Transcript  << 'No verification result for ' << iterations asString << ' found'; cr.
    Transcript << 'Result is: ' << result asString; cr.
    ^ false
]
