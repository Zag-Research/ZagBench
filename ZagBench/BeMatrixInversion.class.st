Class {
	#name : 'BeMatrixInversion',
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

{ #category : 'fixThis' }
BeMatrixInversion >> createIdentityMatrix [
	"Creates a new identity matrix of a given size."
	
	| identity identityMatrix|
	identityMatrix := (1 to: size) collect: [ :i |
		(1 to: size) collect: [ :j | (i = j) ifTrue: [ 1.0 ] ifFalse: [ 0.0 ] ] ].
	^ self from: identityMatrix.
]

{ #category : 'fixThis' }
BeMatrixInversion >> at: aRow and: aCol put: aValue[
	"Sets the element at the specified row and column to a new value."
	(elements at: aRow) at: aCol put: aValue]

{ #category : 'fixThis' }
BeMatrixInversion >> createAugmentedMatrix [
	"Create an augmented matrix by combining the original matrix
	   with an identity matrix of the same size."

	| augmentedMatrix identity invertedMatrix Matrix rows |
	identity := Matrix identity: rows.
	augmentedMatrix := (1 to: rows) collect: [ :i |
		(self elements at: i), (identity elements at: i) ].
]

{ #category : 'fixThis' }
BeMatrixInversion >> partialPivoting [
"Partial Pivoting: Find the row with the largest pivot element."

| maxVal maxRow rows augmentedMatrix|
	1 to: rows do: [ :pivotRow |

		maxVal := (augmentedMatrix at: pivotRow) at: pivotRow.
		maxRow := pivotRow.
		pivotRow + 1 to: rows do: [ :currentRow |
			((augmentedMatrix at: currentRow) at: pivotRow) abs > maxVal abs ifTrue: [
				maxVal := (augmentedMatrix at: currentRow) at: pivotRow.
				maxRow := currentRow.
			]
		]] .
]

{ #category : 'fixThis' }
BeMatrixInversion >> performGaussianElimination [
"Perform Gaussian elimination to transform the left side into an identity matrix."

|rows  maxVal maxRow augmentedMatrix pivotRow  |
1 to: rows do: [ :pivotRow |
		"Partial Pivoting: Find the row with the largest pivot element."
		maxVal := (augmentedMatrix at: pivotRow) at: pivotRow.
		maxRow := pivotRow.
		pivotRow + 1 to: rows do: [ :currentRow |
			((augmentedMatrix at: currentRow) at: pivotRow) abs > maxVal abs ifTrue: [
				maxVal := (augmentedMatrix at: currentRow) at: pivotRow.
				maxRow := currentRow.
			]
		]
	].
]

{ #category : 'fixThis' }
BeMatrixInversion >> swapRowsIfHigherRowsFound	[
| tempRow maxRow pivotRow augmentedMatrix|
	maxRow ~= pivotRow ifTrue: [
			
			tempRow := augmentedMatrix at: pivotRow.
			augmentedMatrix at: pivotRow put: (augmentedMatrix at: maxRow).
			augmentedMatrix at: maxRow put: tempRow.
		].
]

{ #category : 'fixThis' }
BeMatrixInversion >> extractInverseMatrix [

| invertedMatrix Matrix rows augmentedMatrix aStream|

invertedMatrix := (1 to: rows) collect: [ :i |
		(augmentedMatrix at: i) copyFrom: rows + 1 to: rows * 2 ].

	^ Matrix from: invertedMatrix.

	"Prints a representation of the matrix to a stream."
	aStream nextPutAll: 'Matrix('; nextPutAll: self rows asString; nextPutAll: 'x'; nextPutAll: self cols asString; nextPutAll: ')'.
	self elements do: [ :row |
		aStream cr; nextPutAll: '  '; nextPutAll: row printString.
	].
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
	
	^ false
]
