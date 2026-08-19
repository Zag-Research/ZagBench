Class {
	#name : 'BeDataFrame',
	#superclass : 'Benchmark',
	#instVars : [
		'columns'
	],
	#classVars : [
		'DataFrame'
	],
	#category : 'ZagBench-DataFrame',
	#package : 'ZagBench',
	#tag : 'DataFrame'
}

{ #category : 'rendering' }
BeDataFrame >> columnNames [ 
^columns
]

{ #category : 'as yet unclassified' }
BeDataFrame >> dataSetFile [
    ^ 'data/mnist_test.csv' asFileReference
]

{ #category : 'running' }
BeDataFrame >> innerBenchmarkLoop [
    ^ self verify: (self loadDataFrame: innerIterations) inner: innerIterations
]

{ #category : 'as yet unclassified' }
BeDataFrame >> loadDataFrame: iterations [
    | allLines header rows csvString |
    allLines := self rawLines.
    header := allLines first.
    rows := (allLines allButFirst) first: iterations.
    csvString := String streamContents: [ :s |
        s nextPutAll: header; cr.
        rows do: [ :line | s nextPutAll: line; cr ] ].
    ^ DataFrame readFromCsvHandRolled: csvString
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

{ #category : 'as yet unclassified' }
BeDataFrame >> trimSeparators [
]

{ #category : 'verification' }
BeDataFrame >> verify: result inner: innerIterations [
    (result isKindOf: DataFrame) ifFalse: [ ^ false ].
    result numberOfRows = innerIterations ifFalse: [ ^ false ].
    result numberOfColumns = 785 ifFalse: [ ^ false ].
    ^ true


]
