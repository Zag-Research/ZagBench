Class {
	#name : 'AnObsoleteBeMemoizedFibonacci',
	#superclass : 'Object',
	#instVars : [
		'cache'
	],
	#category : 'ZagBench-BeMemoizedFibonacci',
	#package : 'ZagBench',
	#tag : 'BeMemoizedFibonacci'
}

{ #category : 'as yet unclassified' }
AnObsoleteBeMemoizedFibonacci >> clearCache [
    cache := Dictionary new.
]

{ #category : 'as yet unclassified' }
AnObsoleteBeMemoizedFibonacci >> fibMemo: n [
    "Return cached result if exists, otherwise calculate and cache"
    | result |
    
    n <= 1 ifTrue: [ ^ n ].
    
    cache at: n ifPresent: [ :value | ^ value ].
    
    result := (self fibMemo: n - 1) + (self fibMemo: n - 2).
    cache at: n put: result.
    
    ^ result.
]

{ #category : 'as yet unclassified' }
AnObsoleteBeMemoizedFibonacci >> initialize [
    super initialize.
    cache := Dictionary new.
]
