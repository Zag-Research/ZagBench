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
		'andomTreesTest',
		'randomTreesTest',
		'bench',
		'stats'
	],
	#category : 'ZagBench-Tests-RandomTrees',
	#package : 'ZagBench-Tests',
	#tag : 'RandomTrees'
}

{ #category : 'as yet unclassified' }
BeRandomTreesTest >> BenchmarkTreeChopTest [

	| bench stats |
	#( 2000 4000 ) do: [ :n |
			#( 4 8 ) do: [ :c |
					bench := BenchmarkTreeChop new.
					bench nodeCount: n.
					bench maxChildren: c.
					bench seconds: 0.4.
					bench prepareTree.
					stats := bench runIterations: 10.
					bench printStats: stats label: 'CHOP | nodes: ' , n printString , ' | children: ' , c printString ] ]
]

{ #category : 'as yet unclassified' }
BeRandomTreesTest >> BenchmarkTreeGrowTest [

	| bench stats |
	Transcript
		open;
		clear.
	#( 2000 4000 ) do: [ :n |
			#( 4 8 ) do: [ :c |
					bench := BenchmarkTreeGrow new.
					bench maxChildren: c.
					bench seconds: 0.4.
					stats := bench runIterations: n.
					bench printStats: stats label: 'GROW | nodes: ' , n printString , ' | children: ' , c printString ] ]
]
