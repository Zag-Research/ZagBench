Class {
	#name : 'FannkuchTest',
	#superclass : 'TestCase',
	#category : 'ZagBench-Test',
	#package : 'ZagBench',
	#tag : 'Test'
}

{ #category : 'as yet unclassified' }
FannkuchTest >> testSimpleCases [

	self assert: (BeFannkuchSimple new solve: 1) equals: #(0 0).
	self assert: (BeFannkuchSimple new solve: 2) equals: #(1 1).
	self assert: (BeFannkuchSimple new solve: 3) equals: #(2 2).
	self assert: (BeFannkuchSimple new solve: 4) equals: #(11 4).
	self assert: (BeFannkuchSimple new solve: 5) equals: #(11 7).
	self assert: (BeFannkuchSimple new solve: 6) equals: #(49 10).
	self assert: (BeFannkuchSimple new solve: 7) equals: #(228 16)
]
