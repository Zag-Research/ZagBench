Class {
	#name : 'BeMatrixInversion',
	#superclass : 'Benchmark',
	#instVars : [
		'matrix',
		'sourceMatrix',
		'size',
		'augmentedMatrix'
	],
	#classInstVars : [
		'size'
	],
	#category : 'ZagBench-MatrixInversion',
	#package : 'ZagBench',
	#tag : 'MatrixInversion'
}

{ #category : 'benchmarking' }
BeMatrixInversion class >> innerIterations [

	^ 250
]


{ #category : 'initialization' }
BeMatrixInversion >> initialize [

	super initialize.
	size := 10.
	sourceMatrix := random makeInvertable: size
]

{ #category : 'running' }
BeMatrixInversion >> innerBenchmarkLoop: iterations [

	| result |
	result := true.
	1 to: iterations do: [ :i | result := result and: self multiplyInverse ].
	^ result
]

{ #category : 'running' }
BeMatrixInversion >> multiplyInverse [ 
	" calculate the inverse of sourceMatrix - non-destructively "
	" then multiply that by sourceMatrix and return true if the result is close to an identity matrix, else false "
	" please just do this... connect the pieces you have "
	^ false
]


