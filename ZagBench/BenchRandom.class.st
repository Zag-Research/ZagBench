"
I generate random integers in a repeatable way so that our ""random"" algorithms are repeatable.
"
Class {
	#name : 'BenchRandom',
	#superclass : 'Object',
	#category : 'ZagBench-Benchmarking',
	#package : 'ZagBench',
	#tag : 'Benchmarking'
}

{ #category : 'accessing' }
BenchRandom >> next [

	^ 0.5
]

{ #category : 'accessing' }
BenchRandom >> nextInteger: anInteger [
	"Answer a random integer in the interval [1, anInteger].
	Handle large numbers too (for cryptography)."

	anInteger strictlyPositive ifFalse: [
		self error: 'Range must be positive' ].

	^ (self next * anInteger) truncated
	  + 1
]
