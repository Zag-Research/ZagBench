Class {
	#name : 'BeRandomTreesTest',
	#superclass : 'TestCase',
	#instVars : [
		'children'
	],
	#classVars : [
		'BenchmarkTreeChopTest'
	],
	#classInstVars : [
		'randomTreesTest'
	],
	#category : 'ZagBench-Tests-RandomTrees',
	#package : 'ZagBench-Tests',
	#tag : 'RandomTrees'
}

{ #category : 'as yet unclassified' }
BeRandomTreesTest class >> BenchmarkTreeChopTest [

	<script>
	| bench stats label |
	#( 20000 40000 80000 ) do: [ :n |
			#( 4 8 ) do: [ :c |
					bench := BeRandomTreeNode new.
					bench maxChildren: c.
					bench seconds: 0.4.
					stats := bench runIterations: n.
					label := String streamContents: [ :stream |
							         stream
								         nextPutAll: 'Chop | nodes: ';
								         print: n;
								         nextPutAll: '| children: ';
								         print: c ].
					bench printStats: stats label: label ] ]
]

{ #category : 'as yet unclassified' }
BeRandomTreesTest class >> BenchmarkTreeGrowTest [

	<script>
	| bench stats label |
	Transcript
		open;
		clear.
	Transcript
		show: 'GROW BENCHMARKS';
		show: String lf.
	#( 20000 40000 80000 ) do: [ :n |
			#( 4 8 ) do: [ :c |
					bench := BeRandomTreeNode new.
					bench maxChildren: c.
					bench seconds: 0.4.
					stats := bench runIterations: n.
					label := String streamContents: [ :stream |
							         stream
								         nextPutAll: 'GROW | nodes: ';
								         print: n;
								         nextPutAll: ' | children: ';
								         print: c ].
					bench printStats: stats label: label ] ]
]

{ #category : 'benchmarking' }
BeRandomTreesTest class >> benchmarkFullGC [

	<script>
	| bench stats label |
	Transcript
		show: 'FULL GC BENCHMARKS';
		show: String lf.
	#( 20000 40000 80000 ) do: [ :n |
			#( 4 8 ) do: [ :c |
					bench := BeStressGC new.
					bench maxChildren: c.
					bench seconds: 0.4.
					stats := bench runIterations: n.
					label := String streamContents: [ :stream |
							         stream
								         nextPutAll: 'Full GC| nodes:';
								         print: n;
								         nextPutAll: ' | children: ';
								         print: c ].
					bench printStats: stats label: label ] ]
]

{ #category : 'as yet unclassified' }
BeRandomTreesTest >> beDataFrameTest [

| bench |
bench := BeDataFrame new.
bench loadDataFrame: BeDataFrame innerIterations.
Transcript
    showCr: 'expected innerIterations: ', BeDataFrame innerIterations printString;
    showCr: 'numberOfRows: ', bench numberOfRows printString;
    showCr: 'numberOfColumns: ', bench numberOfColumns printString;
    showCr: 'first 5 columnNames: ', (bench columnNames first: 5) printString;
    showCr: 'last 3 columnNames: ', (bench columnNames last: 3) printString.
]
