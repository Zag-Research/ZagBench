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
					bench := BenchmarkRandomTrees new.
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
					bench := BenchmarkTreeGrow new.
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
					bench := BenchmarkRandomTrees new.
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
