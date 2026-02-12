Class {
	#name : 'MatrixInversionTest',
	#superclass : 'TestCase',
	#category : 'ZagBench-Test',
	#package : 'ZagBench',
	#tag : 'Test'
}

{ #category : 'tests' }
MatrixInversionTest >> testIdentity [

	| matrix |
	matrix := BeMatrix new: 10.
	self assert: matrix size equals: 10.
	self deny: matrix isIdentityMatrix
]
