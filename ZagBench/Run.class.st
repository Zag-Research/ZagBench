"
Benchmark runner

Orginally based on https://github.com/smarr/are-we-fast-yet/blob/master/benchmarks/Smalltalk/Run.som which has the following copyright:

Copyright (c) 2011-2016 see AUTHORS.md file

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the 'Software'), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
"
Class {
	#name : 'Run',
	#superclass : 'Object',
	#instVars : [
		'name',
		'benchmarkSuite',
		'total',
		'numIterations',
		'innerIterations',
		'totalsq'
	],
	#classVars : [
		'ScriptConsole'
	],
	#category : 'ZagBench-Benchmarking',
	#package : 'ZagBench',
	#tag : 'Benchmarking'
}

{ #category : 'reflective operations' }
Run class >> doesNotUnderstand: aMessage [

	^ self new initialize: aMessage selector
]

{ #category : 'class initialization' }
Run class >> initialize [

	ScriptConsole := Transcript
]

{ #category : 'as yet unclassified' }
Run >> doRuns: bench [
    1 to: numIterations do: [:i |
      self measure: bench
    ]
]

{ #category : 'initialization' }
Run >> initialize: aName [

	name            := aName.
	benchmarkSuite  := self loadBenchmarkSuite: aName.
	total           := 0.
	totalsq         := 0.
	numIterations   := 10.
	innerIterations := 250000.
]

{ #category : 'initialization' }
Run >> loadBenchmarkSuite: className [
    | cls |
    cls := Smalltalk classNamed: className.
    cls ifNil: [
        self error: 'Failed loading benchmark: ', className ].
    ^ cls
]

{ #category : 'as yet unclassified' }
Run >> measure: bench [

	| startTime endTime runTime |
	startTime := Time primUTCMicrosecondsClock.
	(bench innerBenchmarkLoop: innerIterations) ifFalse: [
      self error: 'Benchmark failed with incorrect result'. ].
	endTime   := Time primUTCMicrosecondsClock.

	runTime := endTime - startTime.
	self printResult: runTime.

	totalsq := totalsq + (runTime * runTime).
	total := total + runTime.
]

{ #category : 'as yet unclassified' }
Run >> printResult: runTime [
    ScriptConsole println: (name, ': iterations=1 runtime: ', runTime asString, 'us')
]

{ #category : 'as yet unclassified' }
Run >> printTotal [
    ScriptConsole println: ('Total Runtime: ', total asString, 'us')
]

{ #category : 'as yet unclassified' }
Run >> reportBenchmark [

	| mean stdDev |
	mean := total // numIterations.
	stdDev := self stdDev.
	ScriptConsole println: (name, ': n=', numIterations asString,
     ' mean: ', mean asString, 'us stdDev: ', stdDev asString, ' ', ((stdDev/mean*1000) asInteger * 0.1) asString, '%').
]

{ #category : 'initialization' }
Run >> runBenchmark [
    ScriptConsole println: ('Starting ', name, ' benchmark ... ').

    self doRuns: benchmarkSuite new.
    self reportBenchmark.

    ScriptConsole println: ''
]

{ #category : 'as yet unclassified' }
Run >> stdDev [

	^ (totalsq / numIterations - (total / numIterations) squared ) sqrt
]
