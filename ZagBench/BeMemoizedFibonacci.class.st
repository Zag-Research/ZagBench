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

{ #category : 'benchmarking' }
BeMemoizedFibonacci class >> innerIterations [

	^ 2500000
]

{ #category : 'as yet unclassified' }
BeMemoizedFibonacci >> clearCache [
    cache := Dictionary new.
]

{ #category : 'as yet unclassified' }
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
	1 to: iterations do: [ :i | result := result and: (self fibMemo: 1000) = 43466557686937456435688527675040625802564660517371780402481729089536555417949051890403879840079255169295922593080322634775209689623239873322471161642996440906533187938298969649928516003704476137795166849228875 ].
	^ result
]
