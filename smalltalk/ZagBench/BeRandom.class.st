"
I generate random integers in a repeatable way so that our ""random"" algorithms are repeatable.
"
Class {
	#name : 'BeRandom',
	#superclass : 'Object',
	#instVars : [
		'rand',
		'multiplier',
		'increment',
		'modulus',
		'scale'
	],
	#category : 'ZagBench-Benchmarking',
	#package : 'ZagBench',
	#tag : 'Benchmarking'
}

{ #category : 'random value creation' }
BeRandom >> between: low and: high [
	"Answer a random integer in the interval [1, anInteger].
	Handle large numbers too (for cryptography)."

	^ (self next * (high - low + 1)) truncated + low
]

{ #category : 'initialization' }
BeRandom >> initialize [

	super initialize.
	rand := 12345. "Choose an initial seed value"
	multiplier := 1103515245. "Multiplier constant"
	increment := 12345. "Increment constant"
	modulus := 2 raisedTo: 31. "Modulus "
	scale := 1.0 / modulus asFloat
]

{ #category : 'random value creation' }
BeRandom >> makeInvertable: size [

	^ (self randomSquare: size) withIndexDo: [ :row :index |
		row
			at: index
			put: (row inject: 0 into: [ :sum :each | sum + each abs ]) ];
		yourself
]

{ #category : 'random value creation' }
BeRandom >> next [
	rand := multiplier * rand + increment \\ modulus . "Linear congruential generator formula"
	^ rand * scale
]

{ #category : 'random value creation' }
BeRandom >> nextInteger: anInteger [
	"Answer a random integer in the interval [1, anInteger].
	Handle large numbers too (for cryptography)."

	anInteger strictlyPositive ifFalse: [
		self error: 'Range must be positive' ].

	^ (self next * anInteger) truncated
	  + 1
]

{ #category : 'random value creation' }
BeRandom >> randomSquare: anInteger [

	^ self randomWithRows: anInteger columns: anInteger
]

{ #category : 'random value creation' }
BeRandom >> randomWithRows: rows columns: cols [

	^ (1 to: rows) collect: [ :i |
		  (1 to: cols) collect: [ :j | self next ] ]
]
