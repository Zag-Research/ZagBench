"
I implement the classic N-Queens problem
"
Class {
	#name : 'BeQueens',
	#superclass : 'Benchmark',
	#instVars : [
		'freeRows',
		'freeMaxs',
		'freeMins',
		'queenRows'
	],
	#category : 'ZagBench-Queens',
	#package : 'ZagBench',
	#tag : 'Queens'
}

{ #category : 'benchmarking' }
BeQueens class >> innerIterations [

	^ 30000
]

{ #category : 'running' }
BeQueens >> innerBenchmarkLoop: iterations [

	| result |
	result := true.
	1 to: iterations do: [ :i | result := result and: self queens ].
	^ result
]

{ #category : 'as yet unclassified' }
BeQueens >> placeQueen: c [
    1 to: 8 do: [ :r | 
      (self row: r column: c)
        ifTrue: [
          queenRows at: r put: c.
          self row: r column: c put: false.
          (c = 8) ifTrue: [ ^ true ].
          (self placeQueen: c + 1) ifTrue: [ ^ true ].
          self row: r column: c put: true ] ].
    ^ false
]

{ #category : 'initialization' }
BeQueens >> queens [

	freeRows := Array new: 8 withAll: true.
	freeMaxs := Array new: 16 withAll: true.
	freeMins := Array new: 16 withAll: true.
	queenRows := Array new: 8 withAll: -1.
	^ self placeQueen: 1
]

{ #category : 'as yet unclassified' }
BeQueens >> row: r column: c [
    ^ (freeRows at: r) and: [(freeMaxs at: c + r) and: [(freeMins at: c - r + 8)]]
]

{ #category : 'as yet unclassified' }
BeQueens >> row: r column: c put: v [
    freeRows at: r         put: v.
    freeMaxs at: c + r     put: v.
    freeMins at: c - r + 8 put: v.
]
