Class {
	#name : 'BeRandomTrees',
	#superclass : 'Object',
	#instVars : [
		'nodeCount',
		'maxChildren',
		'root',
		'random'
	],
	#category : 'ZagBench-BeRandomTrees',
	#package : 'ZagBench',
	#tag : 'BeRandomTrees'
}

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

    Transcript
        show: 'Cut ~50%% of subtrees. Approx ', cutCount printString, ' nodes now GC eligible.';
        nl.
    ^ self
]

{ #category : 'as yet unclassified' }
BeRandomTrees >> cutRandomSubtree [
    "Detach a random non-root node and its entire subtree, making it eligible for GC."
    | allNodes pick parent cutSize |
    allNodes := root allNodes.
    allNodes size <= 1 ifTrue: [
        Transcript show: 'Tree is empty or has only root — nothing to cut.'; nl.
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

    Transcript
        show: 'Cut subtree of ', cutSize printString,
              ' nodes (root was node #', pick value printString, '). Now unreachable — GC eligible.';
        nl.
    ^ self
]

{ #category : 'as yet unclassified' }
BeRandomTrees >> initialize [
    
| tree nodeCount maxChildren random root |

tree := BeRandomTrees new .
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
| tree nodeCount maxChildren  build |

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
