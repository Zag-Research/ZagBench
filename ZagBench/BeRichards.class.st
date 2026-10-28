Class {
	#name : 'BeRichards',
	#superclass : 'Benchmark',
	#category : 'ZagBench-Benchmarking',
	#package : 'ZagBench',
	#tag : 'Benchmarking'
}

{ #category : 'running' }
BeRichards >> innerBenchmarkLoop: n [
    1 to: n do: [ :i | BeRichardsBenchmark new start ].
    ^ true
]

{ #category : 'accessing' }
BeRichards >> innerIterations [ 
^ 1 
]
