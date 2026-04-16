Class {
	#name : 'MatrixInversionTest',
	#superclass : 'TestCase',
	#category : 'ZagBench-Test',
	#package : 'ZagBench',
	#tag : 'Test'
}

{ #category : 'tests' }
MatrixInversionTest >> testBeMatrixInversion [
| m result | 
m :=BeMatrixInversion new.
m initialize.

Transcript show: 'size:' , m sourceMatrix size printString; cr.

result:= m sourceMatrix inverted.

Transcript show: 'Inverse Matrix:'; cr.
1 to: m sourceMatrix size do: [ :row|  
	1 to: m sourceMatrix size do: [ :col |
		Transcript show: ((result at: row and: col)printString), '' ].
	Transcript cr ].
]

{ #category : 'tests' }
MatrixInversionTest >> testIdentity [

	| matrix |
	matrix := BeMatrix new: 10.
	self assert: matrix size equals: 10.
	self deny: matrix isIdentityMatrix
]

{ #category : 'tests' }
MatrixInversionTest >> testMatrix [ 
|m|
m:= BeMatrix new.
Transcript show:'ok'; cr.
]

{ #category : 'tests' }
MatrixInversionTest >> testSize [
|m|
m:= BeMatrix new.
m with: #(    
#(1.0 2.0 3.0)
#(0.0 4.0 5.0)
#(1.0 0.0 6.0)
).
Transcript show:'size:',m size printString; cr.  " Type without the method name in playground"
]
