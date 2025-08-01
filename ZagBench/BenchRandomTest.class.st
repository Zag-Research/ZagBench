Class {
	#name : 'BenchRandomTest',
	#superclass : 'TestCase',
	#instVars : [
		'gen'
	],
	#category : 'ZagBench-Test',
	#package : 'ZagBench',
	#tag : 'Test'
}

{ #category : 'running' }
BenchRandomTest >> setUp [

	super setUp.
	gen := BeRandom new
]

{ #category : 'tests' }
BenchRandomTest >> testDistribution [

	| results occurrences |
	1 to: 100 do: [ :i |
		results := Bag new.
		2000 timesRepeat: [ results add: (gen nextInteger: 100) ].
		occurrences := Array new: 100 streamContents: [ :out |
			               results doWithOccurrences: [ :element :occurrence |
				               self assert: (element between: 1 and: 100).
				               out nextPut: occurrence
				               "self assert: (occurrence between: 5 and: 40)" ] ].
		self assert: occurrences average equals: 2000. "20"
		self assert: occurrences stdev < 10 ]
]

{ #category : 'tests' }
BenchRandomTest >> testNext [

	10000 timesRepeat: [
		| next |
		next := gen next.
		self assert: next >= 0.
		self assert: next < 1 ]
]
