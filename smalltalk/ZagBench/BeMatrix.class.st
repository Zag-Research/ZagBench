Class {
	#name : 'BeMatrix',
	#superclass : 'Object',
	#instVars : [
		'matrix',
		'augmented',
		'maxRow',
		'size'
	],
	#classInstVars : [
		'inverted'
	],
	#category : 'ZagBench-MatrixInversion',
	#package : 'ZagBench',
	#tag : 'MatrixInversion'
}

{ #category : 'instance creation' }
BeMatrix class >> new: size [

	^ self basicNew size: size
]

{ #category : 'arithmetic' }
BeMatrix >> * otherMatrix [
	" FIXED - was sending `at:at:put:`, which BeMatrix never defined (only
	  the 2-arg getter at:and: existed, no setter at all).  "
	| n resultMatrix sum |
	n := self size.
	resultMatrix := self class new: n.
	1 to: n do: [ :i |
		1 to: n do: [ :j |
			sum := 0.0.
			1 to: n do: [ :k | sum := sum + ((self at: i and: k) * (otherMatrix at: k and: j)) ].
			resultMatrix at: i and: j put: sum ] ].
	^ resultMatrix
]

{ #category : 'converting' }
BeMatrix >> asOrderedCollection [
matrix := (1 to: size) collect: [ : r | Array new: size withAll: 0.0] asOrderedCollection.
]

{ #category : 'accessing' }
BeMatrix >> at: row and: col [

	^ (matrix at: row) at: col
]

{ #category : 'accessing' }
BeMatrix >> at: row and: col put: aValue [
	" NEW - setter counterpart to at:and:. Nothing in the class could write
	  into a result matrix by index before this; * needs it to fill in
	  each product entry. "
	^ (matrix at: row) at: col put: aValue
 
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

{ #category : 'printing' }
BeMatrix >> printString [
   " FIXED - ifNil:/ifEmpty: results were being discarded (no ^), so an
     uninitialized/empty matrix silently fell through to the loop below
     instead of returning the descriptive string. "
   | stream |
   matrix ifNil: [ ^ 'BeMatrix uninitialized' ].
   matrix ifEmpty: [ ^ 'BeMatrix is empty' ].
   stream := WriteStream on: String new.
   1 to: self size do: [ :row |
	1 to: self size do: [ :column |
		stream nextPutAll: ((self at: row and: column) printString).
		column < self size ifTrue: [ stream nextPutAll: ' ' ] ].
	stream nextPut: Character lf ].
   ^ stream contents
]

{ #category : 'accessing' }
BeMatrix >> rows [

	matrix ifNil: [ ^ 0 ].
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

	^ self rows
]

{ #category : 'accessing' }
BeMatrix >> size: size [
	" FIXED - Smalltalk sends unary
	  messages before keyword messages, so `asOrderedCollection` was binding
	  to the BLOCK LITERAL itself, not to the result of collect:. That block
	  doesn't understand asOrderedCollection - which is exactly why the
	  debugger showed FullBlockClosure>>asOrderedCollection / shouldBeImplemented
	  on the stack: an earlier 'Create' click on that same DNU had stubbed
	  the method onto FullBlockClosure rather than fixing the real bug.
	  Adding parens around the collect: forces asOrderedCollection to apply
	  to the resulting collection instead. "
	matrix := ((1 to: size) collect: [ :r | Array new: size withAll: 0.0 ]) asOrderedCollection
 
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
	" FIXED - `maxRow = 1.` was an equality test, not an assignment, so
	  maxRow was silently left nil. Currently harmless (inverted always sets
	  maxRow := col before using it), but it's real dead/wrong code, not what
	  was intended, so fixed to := for when this is reused elsewhere. "
	matrix := OrderedCollection new.
	aCollection collect: [ :row |
		matrix add: row asOrderedCollection ].
	augmented := OrderedCollection new.
	maxRow := 1.


]
