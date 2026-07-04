Class {
	#name : 'RandomTreeNode',
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
RandomTreeNode >> addChild: aNode [
    aNode parent: self.
    children add: aNode
]

{ #category : 'helpers' }
RandomTreeNode >> allNodes [
    | result |
    result := OrderedCollection new.
    result add: self.
    (children ifNil: [OrderedCollection new])
        do: [:child | result addAllLast: child allNodes].
    ^ result
]

{ #category : 'accessing' }
RandomTreeNode >> children [
^children
]

{ #category : 'as yet unclassified' }
RandomTreeNode >> initialize [
    super initialize.
    children := OrderedCollection new.
    value := 0.
    parent := 0.
]

{ #category : 'accessing' }
RandomTreeNode >> parent [
^parent 
]

{ #category : 'accessing' }
RandomTreeNode >> parent: aNode [
    parent := aNode
]

{ #category : 'printing' }
RandomTreeNode >> printOn: aStream [
    aStream
        nextPutAll: 'RandomTreeNode(';
        print: value;
        nextPut: $)
]

{ #category : 'accessing' }
RandomTreeNode >> subtreeSize [
    ^ children inject: 1 into: [:sum :child | sum + child subtreeSize]
]

{ #category : 'evaluating' }
RandomTreeNode >> value [
^value 
]

{ #category : 'accessing' }
RandomTreeNode >> value: anObject [
    value := anObject


]
