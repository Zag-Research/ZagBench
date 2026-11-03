"
A BeFannkuchSimpleTest is a test class for testing the behavior of BeFannkuchSimple
"
Class {
	#name : 'BeFannkuchSimpleTest',
	#superclass : 'TestCase',
	#category : 'ZagBench-Tests-FannkuchSimple',
	#package : 'ZagBench-Tests',
	#tag : 'FannkuchSimple'
}

{ #category : 'tests' }
BeFannkuchSimpleTest >> testFannkuch [

	self  assert: ( BeFannkuchSimple new fannkuch: 1) equals: #(0 0).
	self  assert: ( BeFannkuchSimple new fannkuch: 2) equals: #(0 1)

]
