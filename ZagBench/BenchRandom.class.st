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

{ #category : 'as yet unclassified' }
BenchRandom >> LcgFloat [
	"|lcg |
	lcg := BenchRandom new.
	^ Array rows: 10 columns: 6 tabulate: [ :i :j | random next ]"
	| randomArray size seed a c m currentValue rand lcg|
BenchRandom class >> lcg .
	^ self new initialize. 
	
	size := 10. "Define the size of the array"
	seed := 12345. "Choose an initial seed value"
	a := 1103515245. "Multiplier constant"
	c := 12345. "Increment constant"
	m := 2 raisedTo: 31. "Modulus "
	randomArray := OrderedCollection new. "Create an empty collection to store random numbers"
	rand := seed. "Set the initial value to the seed"
	
	
	rand := BenchRandom between: 0 and: 100.
	"(1 to: 10) collect: [ :ignore | rand nextFloat ]."
	1 to: size do: [ :i |
		rand := a * rand + c \\ m. "Linear congruential generator formula"
		randomArray add: rand / m * 100 ."Scale the result to a range between 0 and 100" ].

	^ randomArray asArray "Return the array" 
	


	
	
]

{ #category : 'as yet unclassified' }
BenchRandom >> createRowAndColumn [
	"comment stating purpose of instance-side method"

	"scope: class-variables  &  instance-variables"

	| random rows matrix cols|
	random := Random new.
	matrix := (1 to: rows) collect: [ :i |
		          (1 to: cols) collect: [ :j | random next ] ].
]

{ #category : 'as yet unclassified' }
BenchRandom >> makeInvertable [

	| matrix |
	matrix withIndexDo: [ :row :index |
		row
			at: index
			put: (row inject: 0 into: [ :sum :each | sum + each abs ]) ]
]

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

{ #category : 'as yet unclassified' }
BenchRandom >> randomSquare: anInteger [

	^ self randomWithRows: anInteger columns: anInteger
]
