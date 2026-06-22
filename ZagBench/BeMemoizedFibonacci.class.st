"
I am a benchmark that calulates a large fibonacci number using a memoizing Dictionary.

This is primarily a test of Dictionary and LargeInteger
"
Class {
	#name : 'BeMemoizedFibonacci',
	#superclass : 'Benchmark',
	#instVars : [
		'cache'
	],
	#category : 'ZagBench-MemoizedFibonacci',
	#package : 'ZagBench',
	#tag : 'MemoizedFibonacci'
}

{ #category : 'running' }
BeMemoizedFibonacci >> fibMemo: n [
    "Return cached result if exists, otherwise calculate and cache"
    | result |
    
    n <= 1 ifTrue: [ ^ n ].
    
    cache at: n ifPresent: [ :value | ^ value ].
    
    result := (self fibMemo: n - 1) + (self fibMemo: n - 2).
    cache at: n put: result.
    
    ^ result.
]

{ #category : 'initialization' }
BeMemoizedFibonacci >> initialize [
    super initialize.
    cache := Dictionary new.
]

{ #category : 'running' }
BeMemoizedFibonacci >> innerBenchmarkLoop: iterations [

	| result |
	result := true.
	1 to: iterations do: [ :i | self fibMemo: 200000].
	^ true
]
