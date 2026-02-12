Class {
	#name : 'BeMatrix',
	#superclass : 'Object',
	#instVars : [
		'matrix'
	],
	#category : 'ZagBench-MatrixInversion',
	#package : 'ZagBench',
	#tag : 'MatrixInversion'
}

{ #category : 'instance creation' }
BeMatrix class >> new: size [

	^ self basicNew size: size
]

{ #category : 'instance creation' }
BeMatrix class >> with: array [

	^ self basicNew with: array
]

{ #category : 'accessing' }
BeMatrix >> at: row and: col [

	^ (matrix at: row) at: col
]

{ #category : 'accessing' }
BeMatrix >> columns [

	^ matrix first size
]

{ #category : 'running' }
BeMatrix >> invert [
	" calculate the inverse of self - non-destructively (i.e. return a new BEMatrix) "

	| x resultMatrix |
	x := (1 to: self size) collect: [ : row | |r|
		 r := Array new: self size * 2.
		 r replaceFrom: 1 to: self size with: (matrix at: row) startingAt: 1.
		 1 to: self size do: [ : col | r at: col + self size put: (row = col ifTrue: [ 1.0 ] ifFalse: [ 0.0 ] ) ]
		].
	" x is now the full augmented matrix "
	" now do Gaussian elimination on x "
	" ... "
	" then extract right 1/2 of each row of x into a new matrix "
	resultMatrix := self class new: self size.
	self halt.
	^ resultMatrix
]

{ #category : 'as yet unclassified' }
BeMatrix >> isIdentityMatrix [
	"checks for identity matrix"

	| rows columns |
	rows := self rows.
	columns := self columns.

	1 to: rows do: [ :i |
			1 to: columns do: [ :j |
					| value expected |
					value := self at: i and: j.
					expected := i = j
						            ifTrue: [ 1 ]
						            ifFalse: [ 0 ].
					value = expected ifFalse: [ ^ false ] ] ].
	^ true
]

{ #category : 'accessing' }
BeMatrix >> rows [

	^ matrix size
]

{ #category : 'accessing' }
BeMatrix >> size [

	^ self rows
]

{ #category : 'accessing' }
BeMatrix >> size: size [

	matrix := (1 to: size) collect: [ : r | Array new: size ]
]
