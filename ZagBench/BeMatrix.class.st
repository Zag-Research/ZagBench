Class {
	#name : 'BeMatrix',
	#superclass : 'Object',
	#instVars : [
		'matrix',
		'augmented',
		'maxRow'
	],
	#classInstVars : [
		'inverted'
	],
	#category : 'ZagBench-MatrixInversion',
	#package : 'ZagBench',
	#tag : 'MatrixInversion'
}

{ #category : 'converting' }
BeMatrix class >> asSymbol [
	self shouldBeImplemented.
]

{ #category : 'instance creation' }
BeMatrix class >> new: size [

	^ self basicNew size: size
]

{ #category : 'instance creation' }
BeMatrix class >> with: aCollection [

|matrix augmented maxRow|
	matrix:= OrderedCollection new.
	aCollection collect: [ :row |
		matrix add: row asOrderedCollection ].
	augmented := OrderedCollection new.
	maxRow := 1.
		
	
		 
]

{ #category : 'accessing' }
BeMatrix >> at: row and: col [

	^ (matrix at: row) at: col
]

{ #category : 'accessing' }
BeMatrix >> columns [

	^ matrix first size
]

{ #category : 'as yet unclassified' }
BeMatrix >> eliminateRows: col [
    | factor |
    1 to: self size do: [ :row |
        row ~= col ifTrue: [
            factor := (augmented at: row) at: col.
            1 to: self size * 2 do: [ :j |
                (augmented at: row) at: j put:
                    ((augmented at: row) at: j) - 
                    (factor * ((augmented at: col) at: j)) ] ] ].

]

{ #category : 'as yet unclassified' }
BeMatrix >> extractMatrix [
    | resultMatrix row |
    resultMatrix := self class new.
    1 to: self size do: [ :r |
        row := OrderedCollection new.
        1 to: self size do: [ :c |
            row add: ((augmented at: r) at: c + self size) ].
        resultMatrix matrix add: row ].
    ^ resultMatrix
]

{ #category : 'initialization' }
BeMatrix >> initialize [
    matrix := OrderedCollection new.
    augmented := OrderedCollection new.
    maxRow := 1.


]

{ #category : 'running' }
BeMatrix >> inverted [
	" calculate the inverse of self - non-destructively (i.e. return a new BEMatrix) "

	| resultMatrix col r n |
	col:= 1.
	n:= self size.
	maxRow:=col.
	resultMatrix:= nil.
	r:= self makeAugmented .
	[ col <= n ] whileTrue: [  
	" x is now the full augmented matrix "
	" now do Gaussian elimination on x "
	" then extract right 1/2 of each row of x into a new matrix "
	maxRow := self partialPivoting: col.
	r:= self swapRows: col.
	r:= self scalingPivot: col.
	r:= self eliminateRows: col.
	
	col := col + 1. ].
	resultMatrix := self extractMatrix.
    augmented := OrderedCollection new.
    ^ resultMatrix .
	
	"resultMatrix := self class new: self size."
	" extrac the resultMatric from the augmented matrix "
	resultMatrix := self extractMatrix.
	augmented := nil.
	^ resultMatrix.


	

	"resultMatrix := self class new: self size.
	" "extrac the resultMatric from the augmented matrix ""
	self eliminateRows .
	augmented := nil.
	^ resultMatrix "
]

{ #category : 'as yet unclassified' }
BeMatrix >> isIdentityMatrix [
    | rows columns value expected |
    rows := self rows.
    columns := self columns.
    1 to: rows do: [ :i |
        1 to: columns do: [ :j |
            value := self at: i and: j.
            expected := i = j ifTrue: [ 1 ] ifFalse: [ 0 ].
            (value - expected) abs > 1.0e-10 ifTrue: [ ^ false ] ] ].
    ^ true
]

{ #category : 'running' }
BeMatrix >> makeAugmented [
    | row |
    augmented := OrderedCollection new.
    1 to: self size do: [ :r |
        row := OrderedCollection new.
        1 to: self size do: [ :c |
            row add: ((matrix at: r) at: c) asFloat ].   "adds left half"
        1 to: self size do: [ :c |
            row add: (r = c ifTrue: [ 1.0 ] ifFalse: [ 0.0 ]) ].  "adds right half"
        augmented add: row ].
]

{ #category : 'accessing' }
BeMatrix >> matrix [ 
 ^matrix 
]

{ #category : 'as yet unclassified' }
BeMatrix >> partialPivoting: col [
    | maxVal val |
    maxRow := col.
    maxVal := ((augmented at: col) at: col) abs.
    col + 1 to: self size do: [ :row |
        val := ((augmented at: row) at: col) abs.
        val > maxVal ifTrue: [
            maxVal := val.
            maxRow := row ] ].
    ^ maxRow
]

{ #category : 'accessing' }
BeMatrix >> printString [ 
  | stream  |

matrix ifNil: [ 'BeMatrix uninitialized' ].
matrix ifEmpty: [ 'BeMatrix is empty' ].

stream := WriteStream on: String new.
1 to: self size do: [ : row|
	1 to: self size do:[:column|
		stream nextPutAll: ((self at: row and: column)printString).
		column < self size ifTrue: [ stream nextPutAll: '' ] ].
	stream nextPut: Character lf ].
	^ stream contents
	
]

{ #category : 'accessing' }
BeMatrix >> rows [
	matrix isNil ifTrue: [ ^ 0 ].
	^ matrix size
]

{ #category : 'as yet unclassified' }
BeMatrix >> scalingPivot: col [
    | pivot |
    pivot := (augmented at: col) at: col.
    1 to: self size * 2 do: [ :j |
        (augmented at: col) at: j put: ((augmented at: col) at: j) / pivot. ]
]

{ #category : 'initialization' }
BeMatrix >> setMatrix: aCollection [
    matrix := OrderedCollection new.
    aCollection collect: [ :row |
        | newRow |
        newRow := OrderedCollection new.
        row collect: [ :val | newRow add: val asFloat ].
        matrix add: newRow ].
    augmented := OrderedCollection new.
    maxRow := 1.

]

{ #category : 'accessing' }
BeMatrix >> size [
	matrix ifNil: [ ^ 0 ].
	^matrix size
	"^ self rows"
]

{ #category : 'accessing' }
BeMatrix >> size: size [

	matrix := (1 to: size) collect: [ : r | Array new: size withAll: 0.0] asOrderedCollection.

]

{ #category : 'as yet unclassified' }
BeMatrix >> swapRows: col [
    | temp |
    maxRow ~= col ifTrue: [
        temp := augmented at: col.
        augmented at: col put: (augmented at: maxRow).
        augmented at: maxRow put: temp ].
    ((augmented at: col) at: col) abs < 1.0e-10 ifTrue: [
        ^ self error: 'Matrix is singular - cannot be inverted' ].
]

{ #category : 'accessing' }
BeMatrix >> with: aCollection [
	matrix:= OrderedCollection new.
	aCollection collect: [:row |
		matrix add: row asOrderedCollection ].
	augmented := OrderedCollection new.
	maxRow = 1.



]
