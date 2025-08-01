Class {
	#name : 'MatrixInversion',
	#superclass : 'Benchmark',
	#instVars : [
		'matrix',
		'sourceMatrix',
		'size'
	],
	#classInstVars : [
		'size'
	],
	#category : 'ZagBench-MatrixInversion',
	#package : 'ZagBench',
	#tag : 'MatrixInversion'
}

{ #category : 'initialization' }
MatrixInversion >> initialize [

	super initialize.
	size := 10.
	sourceMatrix := random makeInvertable: size
]

{ #category : 'running' }
MatrixInversion >> innerBenchmarkLoop: iterations [

	| result |
	result := true.
	1 to: iterations do: [ :i | result := result and: self multiplyInverse ].
	^ result
]

{ #category : 'running' }
MatrixInversion >> multiplyInverse [ 
	" calculate the inverse of sourceMatrix - non-destructively "
	" then multiply that by sourceMatrix and return true if the result is close to an identity matrix, else false "
	
	^ false
]
