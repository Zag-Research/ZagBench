Class {
	#name : 'BeRandomTreeNode',
	#superclass : 'BeRandomTrees',
	#instVars : [
		'children',
		'value',
		'parent'
	],
	#category : 'ZagBench-RandomTrees',
	#package : 'ZagBench',
	#tag : 'RandomTrees'
}

{ #category : 'adding' }
BeRandomTreeNode >> addChild: aNode [
    aNode parent: self.
    children add: aNode
]

{ #category : 'helpers' }
BeRandomTreeNode >> allNodes [
    | result |
    result := OrderedCollection new.
    result add: self.
    (children ifNil: [OrderedCollection new])
        do: [:child | result addAllLast: child allNodes].
    ^ result
]

{ #category : 'accessing' }
BeRandomTreeNode >> children [
^children
]

{ #category : 'as yet unclassified' }
BeRandomTreeNode >> initialize [
    super initialize.
    children := OrderedCollection new.
    value := 0.
    parent := 0.
]

{ #category : 'accessing' }
BeRandomTreeNode >> parent [
^parent 
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
^value 
]

{ #category : 'accessing' }
BeRandomTreeNode >> value: anObject [
    value := anObject


]
