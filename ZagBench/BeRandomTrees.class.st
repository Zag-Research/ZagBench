Class {
	#name : 'BeRandomTrees',
	#superclass : 'Object',
	#instVars : [
		'root',
		'nodeCount',
		'maxChildren',
		'random'
	],
	#category : 'ZagBench-RandomTrees',
	#package : 'ZagBench',
	#tag : 'RandomTrees'
}

{ #category : 'building' }
BeRandomTrees >> build [
    | queue current childCount child created |
    root := self nodeClass new.
    root value: 0.
    queue := OrderedCollection new.
    queue addLast: root.
    created := 1.
    [created < nodeCount and: [queue notEmpty]] whileTrue: [
        current := queue removeFirst.
        childCount := 1 + (random nextInteger: maxChildren).
        1 to: childCount do: [:i |
            created < nodeCount ifTrue: [
                child := self nodeClass new.
                child value: created.
                current addChild: child.
                queue addLast: child.
                created := created + 1]]].
   
    ^ self
]

{ #category : 'as yet unclassified' }
BeRandomTrees >> cutHalfSubtrees [
    | allNodes cutCount toRemove |
    allNodes := root allNodes.
    cutCount := 0.
    allNodes do: [:node |
        node children size > 1 ifTrue: [
            toRemove := node children select: [:_ | random next < 0.5].
            toRemove do: [:child |
                node children remove: child ifAbsent: [].
                child parent: nil.
                cutCount := cutCount + child subtreeSize]]].
    
    ^ self
]

{ #category : 'as yet unclassified' }
BeRandomTrees >> cutRandomSubtree [
    | allNodes pick parent cutSize |
    allNodes := root allNodes.
    allNodes size <= 1 ifTrue: [
        Transcript show: 'Nothing to cut.'; cr.
        ^ self].
    allNodes := allNodes select: [:n | n ~= root].
    pick := allNodes at: (random nextInteger: allNodes size).
    parent := pick parent.
    cutSize := pick subtreeSize.
    parent ifNotNil: [
        parent children remove: pick ifAbsent: [].
        pick parent: nil].
    
    ^ self
]

{ #category : 'as yet unclassified' }
BeRandomTrees >> garbageCollect [
	"Primitive. Reclaims all garbage and answers the size of the largest free chunk in old space."

	Smalltalk garbageCollect
	
]

{ #category : 'as yet unclassified' }
BeRandomTrees >> garbageCollectMost [
	"Primitive. Reclaims recently created garbage (which is usually most of it) fairly quickly and answers the number of bytes of available space."

	Smalltalk garbageCollectMost
	
]

{ #category : 'initialization' }
BeRandomTrees >> initialize [
    super initialize.
    nodeCount := 1000.
    maxChildren := 4.
    random := Random new.
    root := 0.
]

{ #category : 'as yet unclassified' }
BeRandomTrees >> liveNodes [
    root ifNil: [^ OrderedCollection new].
    ^ root allNodes
]

{ #category : 'accessing' }
BeRandomTrees >> maxChildren: anInteger [
    maxChildren := anInteger
]

{ #category : 'configuration' }
BeRandomTrees >> nodeClass [
	^BeRandomTreeNode 
]

{ #category : 'accessing' }
BeRandomTrees >> nodeCount: anInteger [
    nodeCount := anInteger
]

{ #category : 'printing' }
BeRandomTrees >> printSummary [
    | live |
    live := self liveNodes size.
    Transcript
        show: '--- Tree Summary ---'; cr;
        show: 'Live nodes : ', live printString; cr;
        show: 'Max children: ', maxChildren printString; cr.
]

{ #category : 'accessing' }
BeRandomTrees >> root [
 ^root
]
