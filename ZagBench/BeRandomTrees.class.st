Class {
	#name : 'BeRandomTrees',
	#superclass : 'Object',
	#instVars : [
		'nodeCount',
		'maxChildren',
		'root',
		'random'
	],
	#category : 'ZagBench-RandomTrees',
	#package : 'ZagBench',
	#tag : 'RandomTrees'
}

{ #category : 'building' }
BeRandomTrees >> build [
    "Build a random tree with nodeCount nodes, each having up to maxChildren children."
    | queue current childCount child created |
    root := RandomTreeNode new.
    root value: 0.
    queue := OrderedCollection new.
    queue addLast: root.
    created := 1.

    [created < nodeCount and: [queue notEmpty]] whileTrue: [
        current := queue removeFirst.
        childCount := 1 + (random nextInteger: maxChildren).
        1 to: childCount do: [:i |
            created < nodeCount ifTrue: [
                child := RandomTreeNode new.
                child value: created.
                current addChild: child.
                queue addLast: child.
                created := created + 1
            ]
        ]
    ].

    
    ^ self
]

{ #category : 'as yet unclassified' }
BeRandomTrees >> cutHalfSubtrees [
    "Cut roughly half the children of each node, freeing large portions of the tree."
    | allNodes cutCount |
    allNodes := root allNodes.
    cutCount := 0.

    allNodes do: [:node |
        | toRemove |
        node children size > 1 ifTrue: [
            toRemove := node children select: [:_ | random next < 0.5].
            toRemove do: [:child |
                node children remove: child ifAbsent: [].
                child parent: nil.
                cutCount := cutCount + child subtreeSize.
            ]
        ]
    ].

    
    ^ self
]

{ #category : 'as yet unclassified' }
BeRandomTrees >> cutRandomSubtree [
    "Detach a random non-root node and its entire subtree, making it eligible for GC."
    | allNodes pick parent cutSize |
    allNodes := root allNodes.
    allNodes size <= 1 ifTrue: [
        
        ^ self
    ].

    "Remove root from candidates so we never cut the whole tree from root"
    allNodes := allNodes select: [:n | n ~= root].

    pick := allNodes at: (random nextInteger: allNodes size).
    parent := pick parent.
    cutSize := pick subtreeSize.

    parent ifNotNil: [
        parent children remove: pick ifAbsent: [].
        pick parent: nil.
    ].

    
    ^ self
]

{ #category : 'as yet unclassified' }
BeRandomTrees >> fullGarbageCollect [
    "Trigger Pharo's full GC — scans old space too, reclaims all unreachable objects."
    
    ^  Smalltalk fullGarbageCollect.
   
]

{ #category : 'memory space' }
BeRandomTrees >> garbageCollect [
    "Trigger Pharo's incremental/minor GC (scavenges young space)."
    Smalltalk garbageCollect.
    ^ self
]

{ #category : 'as yet unclassified' }
BeRandomTrees >> initialize [
    
| tree  |

tree := self new .
    nodeCount := 1000.
    maxChildren := 4.
    random := Random new.
    root := nil
    build.

"Cut a subtree — the old references become unreachable"
tree cutRandomSubtree.

"Force a full GC cycle in Pharo"
Smalltalk garbageCollect.

"Or to force a full old-space GC:"
Smalltalk fullGarbageCollect.
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

{ #category : 'accessing' }
BeRandomTrees >> nodeCount: anInteger [
    nodeCount := anInteger
]

{ #category : 'as yet unclassified' }
BeRandomTrees >> randomTree [
| tree  build |

tree := BeRandomTrees new .
    nodeCount:= 5000.
    maxChildren:=4 .
    build.

"Cut a subtree — the old references become unreachable"
tree cutRandomSubtree.

"Force a full GC cycle in Pharo"
Smalltalk garbageCollect.

"Or to force a full old-space GC:"
Smalltalk fullGarbageCollect.
]
