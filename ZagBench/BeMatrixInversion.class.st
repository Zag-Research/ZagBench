Class {
	#name : 'BeMatrixInversion',
	#superclass : 'Benchmark',
	#instVars : [
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

{ #category : 'benchmarking' }
BeMatrixInversion class >> innerIterations [

	^ 250
]

{ #category : 'initialization' }
BeMatrixInversion >> initialize [
|matrix augmented maxRow|
	super initialize.
	size := 10.
	matrix:= OrderedCollection new.
	augmented :=OrderedCollection new.
	maxRow:= 1.

	sourceMatrix := BeMatrix new with: (random makeInvertable: size)
]

{ #category : 'running' }
BeMatrixInversion >> innerBenchmarkLoop: iterations [

	| result |
	result := true.
	1 to: iterations do: [ :i |
	result := result and: [self multiplyInverse ]].
	^ result
]

{ #category : 'running' }
BeMatrixInversion >> multiplyInverse [
	" calculate the inverse of sourceMatrix - non-destructively "

	" then multiply that by sourceMatrix and return true if the result is close to an identity matrix, else false "
	| x resultMatrix |
	x := sourceMatrix inverted.
	resultMatrix := x * sourceMatrix.
	^ resultMatrix isIdentityMatrix
]

{ #category : 'accessing' }
BeMatrixInversion >> sourceMatrix [
	^ sourceMatrix 
]
