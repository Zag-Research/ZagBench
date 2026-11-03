Class {
	#name : 'BeRandomTreeNode',
	#superclass : 'Object',
	#instVars : [
		'value',
		'parent',
		'children'
	],
	#category : 'ZagBench-StressGC',
	#package : 'ZagBench',
	#tag : 'StressGC'
}

{ #category : 'converting' }
BeRandomTreeNode class >> asSymbol [
	self shouldBeImplemented.
]

{ #category : 'adding' }
BeRandomTreeNode >> addChild: aNode [ 
    aNode parent: self.
    children add: aNode
]

{ #category : 'helpers' }
BeRandomTreeNode >> allNodes [

	| result |
	result := OrderedCollection with: self.
	children do: [ :child | result addAllLast: child allNodes ].
	^ result
]

{ #category : 'accessing' }
BeRandomTreeNode >> children [
^ children 
]

{ #category : 'tree cutting' }
BeRandomTreeNode >> cutHalfSubtrees [
	"Cut roughly half of root's direct child subtrees, to generate a burst of garbage in one go."

	| copyChildren half |
	copyChildren := children copy.
	half := copyChildren size // 2.
	1 to: half do: [ :i |
			| victim |
			victim := copyChildren at: i.
			children remove: victim ifAbsent: [ ] ].
	^ self
]

{ #category : 'tree cutting' }
BeRandomTreeNode >> cutRandomSubtree: random [

	| allNodes pick pickParent cutSize |
	allNodes := self allNodes.
	allNodes size = 1 ifTrue: [
			Transcript
				show: 'Nothing to cut.';
				cr.
			^ self ].
	allNodes removeFirst.
	pick := allNodes at: (random nextInteger: allNodes size).
	pickParent := pick parent.
	cutSize := pick subtreeSize.
	pickParent children remove: pick ifAbsent: [ ].
	^ self
]

{ #category : 'initialization' }
BeRandomTreeNode >> initialize [
    super initialize.
    children := OrderedCollection new

]

{ #category : 'accessing' }
BeRandomTreeNode >> liveNodes [

	^ children size + 1
]

{ #category : 'accessing' }
BeRandomTreeNode >> parent [

^ parent 
]

{ #category : 'accessing' }
BeRandomTreeNode >> parent: aNode [
	parent := aNode

]

{ #category : 'printing' }
BeRandomTreeNode >> printOn: aStream [
    aStream
        nextPutAll: 'RandomTreeNode(';
        print: value;
        nextPut: $)

]

{ #category : 'accessing' }
BeRandomTreeNode >> subtreeSize [
    ^ children inject: 1 into: [:sum :child | sum + child subtreeSize]

]

{ #category : 'evaluating' }
BeRandomTreeNode >> value [ 
^ value 
]

{ #category : 'accessing' }
BeRandomTreeNode >> value: aNode [
	value := aNode 
]
