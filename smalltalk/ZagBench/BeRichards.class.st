Class {
	#name : 'BeRichards',
	#superclass : 'Benchmark',
	#category : 'ZagBench-Richards',
	#package : 'ZagBench',
	#tag : 'Richards'
}

{ #category : 'benchmarking' }
BeRichards class >> innerIterations [
	^ 10
]

{ #category : 'running' }
BeRichards >> innerBenchmarkLoop: n [
	1 to: n do: [ :i | BeRichardsCore new start ].
	^ true
]
