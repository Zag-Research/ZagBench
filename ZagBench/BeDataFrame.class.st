Class {
	#name : 'BeDataFrame',
	#superclass : 'Benchmark',
	#classVars : [
		'DataFrame'
	],
	#category : 'ZagBench-DataFrame',
	#package : 'ZagBench',
	#tag : 'DataFrame'
}

{ #category : 'as yet unclassified' }
BeDataFrame >> dataSetFile [

^ 'data/mnist_test.csv' asFileReference




]

{ #category : 'running' }
BeDataFrame >> innerBenchmarkLoop: innerIterations [
    ^ self verify: (self loadDataFrame: innerIterations) inner: innerIterations
]

{ #category : 'as yet unclassified' }
BeDataFrame >> loadDataFrame: innerIterations [
    | header rows csvString |
    header := self rawLines first.
    rows := (self rawLines allButFirst) first: innerIterations.
    csvString := String streamContents: [ :s |
        s nextPutAll: header; cr.
        rows do: [ :line | s nextPutAll: line; cr ] ].
    ^ DataFrame readFromCsv: csvString

]

{ #category : 'as yet unclassified' }
BeDataFrame >> rawLines [

^ 'data/mnist_test.csv' asFileReference
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

{ #category : 'verification' }
BeDataFrame >> verify: result inner: innerIterations [
    (result isKindOf: DataFrame) ifFalse: [ ^ false ].
    result numberOfRows = innerIterations ifFalse: [
        Transcript showCr: 'Expected ', innerIterations asString,
            ' rows, got ', result numberOfRows asString.
        ^ false ].
    result numberOfColumns = 785 ifFalse: [
        Transcript showCr: 'Expected 785 columns, got ', result numberOfColumns asString.
        ^ false ].
    ^ true
]
