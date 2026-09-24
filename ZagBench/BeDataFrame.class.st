Class {
	#name : 'BeDataFrame',
	#superclass : 'Benchmark',
	#instVars : [
		'columns',
		'rows',
		'columnNames',
		'rowsCollection',
		'aCharacter'
	],
	#classVars : [
		'DataFrame'
	],
	#classInstVars : [
		'columnNames',
		'rows'
	],
	#category : 'ZagBench-DataFrame',
	#package : 'ZagBench',
	#tag : 'DataFrame'
}

{ #category : 'benchmarking' }
BeDataFrame class >> innerIterations [

	^ 5000
]

{ #category : 'rendering' }
BeDataFrame >> columnNames [
^columnNames 

	
]

{ #category : 'as yet unclassified' }
BeDataFrame >> dataSetFile [
    ^ 'mnist_test.csv' asFileReference

]

{ #category : 'running' }
BeDataFrame >> innerBenchmarkLoop: innerIterations [
    ^ self verify: (self loadDataFrame: innerIterations) inner: innerIterations
]

{ #category : 'accessing' }
BeDataFrame >> innerIterations [
	^ self class innerIterations
]

{ #category : 'testing' }
BeDataFrame >> isTrimmableChar: cCharacter [
	^ aCharacter = Character space 
	or: [aCharacter = Character tab or: [ aCharacter = Character cr or: [ aCharacter = Character lf ] ] ]
]

{ #category : 'as yet unclassified' }
BeDataFrame >> loadDataFrame: innerIterations [
    | allLines header rowLines |
    allLines := self rawLines.
    header := allLines first.
    rowLines := allLines allButFirst first: innerIterations.
    columnNames := (header findTokens: ',') collect: [ :tok | self trimToken: tok ].
    rows := rowLines collect: [ :line |
        (line findTokens: ',') collect: [ :tok | self trimToken: tok ] ].
    ^ self
]

{ #category : 'accessing' }
BeDataFrame >> numberOfColumns [
    ^ columnNames size
]

{ #category : 'accessing' }
BeDataFrame >> numberOfRows [

	^ rows size 
]

{ #category : 'as yet unclassified' }
BeDataFrame >> rawLines [
    ^ self dataSetFile contents lines

]

{ #category : 'as yet unclassified' }
BeDataFrame >> readFromCsv: aCsvString [
	| lines header parsedRows |
	lines := aCsvString lines reject: #isEmpty.
	

	"Extract the header row"
	header := (lines first findTokens: ',') collect: #trimBoth.

	"Parse remaining rows into row arrays"
	parsedRows := lines allButFirst collect: [ :line |
		(line findTokens: ',') collect: #trimBoth ].

	
]

{ #category : 'as yet unclassified' }
BeDataFrame >> readFromCsvHandRolled: aCsvString [
    | lines header parsedRows |
    lines := aCsvString lines reject: [ :l | l isEmpty ].
    header := (lines first findTokens: ',') collect: [ :tok | tok trimSeparators ].
    parsedRows := (lines allButFirst) collect: [ :line |
        (line findTokens: ',') collect: [ :tok | tok trimSeparators ] ].
    ^ DataFrame withRows: parsedRows columnNames: header
]

{ #category : 'accessing' }
BeDataFrame >> rows [ 
^rows
]

{ #category : 'as yet unclassified' }
BeDataFrame >> trimToken: aString [

	| start stop |
	start := 1.
	stop := aString size.
	
		start <= stop and: [ start := start + 1 ].
		[ stop >= start and: [ self isTrimmableChar: (aString at: start) ] ] whileTrue: [ start := start + 1 ].
		[ stop >= start and: [ self isTrimmableChar: (aString at: stop) ] ] whileTrue: [ stop := stop - 1 ].
		^ aString copyFrom: start to: stop 
]

{ #category : 'verification' }
BeDataFrame >> verify: result inner: innerIterations [
    (result isKindOf: DataFrame) ifFalse: [ ^ false ].
    result numberOfRows = innerIterations ifFalse: [ ^ false ].
    result numberOfColumns = 785 ifFalse: [ ^ false ].
    ^ true


]
