Class {
	#name : 'BeFannkuchPermutationsTest',
	#superclass : 'TestCase',
	#instVars : [
		'gen'
	],
	#category : 'ZagBench-Tests-Benchmarking',
	#package : 'ZagBench-Tests',
	#tag : 'Benchmarking'
}

{ #category : 'test ' }
BeFannkuchPermutationsTest >> permutationsOF: aCollection [ 

	^ (Array streamContents: [:stream | aCollection fkPermutationsDo: [:each | stream nextPut: each copy]])
]

{ #category : 'tests' }
BeFannkuchPermutationsTest >> testPermutationsDo [

	self assert: (self permutationsOF: (1 to: 1)) equals: #( #( 1 ) ).
	self
		assert: (self permutationsOF: (1 to: 2))
		equals: #( #( 1 2 ) #( 2 1 ) ).
	self
		assert: (self permutationsOF: (1 to: 3))
		equals:
		#( #( 1 2 3 ) #( 2 1 3 ) #( 2 3 1 ) #( 3 2 1 ) #( 3 1 2 ) #( 1 3 2 ) ).
	self
		assert: (self permutationsOF: (1 to: 4))
		equals:
			#( #( 1 2 3 4 ) #( 2 1 3 4 ) #( 2 3 1 4 ) #( 3 2 1 4 ) #( 3 1 2 4 )
			   #( 1 3 2 4 ) #( 2 3 4 1 ) #( 3 2 4 1 ) #( 3 4 2 1 ) #( 4 3 2 1 )
			   #( 4 2 3 1 ) #( 2 4 3 1 ) #( 3 4 1 2 ) #( 4 3 1 2 ) #( 4 1 3 2 )
			   #( 1 4 3 2 ) #( 1 3 4 2 ) #( 3 1 4 2 ) #( 4 1 2 3 ) #( 1 4 2 3 )
			   #( 1 2 4 3 ) #( 2 1 4 3 ) #( 2 4 1 3 ) #( 4 2 1 3 ) )
]
