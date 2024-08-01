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
	#name : 'Benchmark',
	#superclass : 'Object',
	#instVars : [
		'name',
		'benchmarkSuite',
		'total',
		'numIterations',
		'innerIterations',
		'totalsq',
		'runTimes',
		'logging'
	],
	#classVars : [
		'ScriptConsole'
	],
	#category : 'ZagBench-Benchmarking',
	#package : 'ZagBench',
	#tag : 'Benchmarking'
}

{ #category : 'reflective operations' }
Benchmark class >> benchmark: aString [

	^ self new initialize: aString
]

{ #category : 'reflective operations' }
Benchmark class >> doesNotUnderstand: aMessage [

	^ self run: aMessage selector
]

{ #category : 'class initialization' }
Benchmark class >> initialize [

	ScriptConsole := Transcript
]

{ #category : 'benchmarking' }
Benchmark class >> innerIterations [

	^ nil
]

{ #category : 'running' }
Benchmark class >> run [

	self == Benchmark ifTrue: [ self error: 'Ue like: Benchmark ', NBody name ].
	self run: name
]

{ #category : 'reflective operations' }
Benchmark class >> run: aString [

	^ (self benchmark: aString) runBenchmark
]

{ #category : 'running' }
Benchmark >> doRuns: bench [
    1 to: numIterations do: [:i |
      self measure: bench
    ]
]

{ #category : 'initialization' }
Benchmark >> initialize [

	super initialize.
	logging := false
]

{ #category : 'initialization' }
Benchmark >> initialize: aName [

	name := aName.
	benchmarkSuite := self loadBenchmarkSuite: aName.
	total := 0.
	totalsq := 0.
	numIterations := 10.
	innerIterations := benchmarkSuite innerIterations ifNil: [ 250000 ].
	runTimes := OrderedCollection new
]

{ #category : 'initialization' }
Benchmark >> loadBenchmarkSuite: className [
    | cls |
    cls := Smalltalk classNamed: className.
    cls ifNil: [
        self error: 'Failed loading benchmark: ', className ].
    ^ cls
]

{ #category : 'running' }
Benchmark >> measure: bench [

	| startTime endTime runTime |
	startTime := Time primUTCMicrosecondsClock.
	(bench innerBenchmarkLoop: innerIterations) ifFalse: [
		self error: 'Benchmark failed with incorrect result' ].
	endTime := Time primUTCMicrosecondsClock.

	runTime := endTime - startTime.
	logging ifTrue: [self printResult: runTime].

	runTimes add: runTime.
	totalsq := totalsq + (runTime * runTime).
	total := total + runTime
]

{ #category : 'reporting' }
Benchmark >> printResult: runTime [

	ScriptConsole
		<<< name;
		<<< ': iterations=1 runtime: ';
		<<< runTime;
		<<< 'us';
		cr
]

{ #category : 'reporting' }
Benchmark >> printTotal [

	ScriptConsole
		<<< 'Total Runtime: ';
		<<< total;
		<<< 'us';
		cr
]

{ #category : 'reporting' }
Benchmark >> reportBenchmark [

	| mean stdDev |
	mean := total // numIterations.
	stdDev := self stdDev.
	ScriptConsole
		<<< name;
		<<< ': n=';
		<<< numIterations;
		<<< ' mean: ';
		<<< mean;
		<<< 'us stdDev: ';
		<<< stdDev asInteger;
		<<< 'us ';
		print: stdDev / mean * 100 withDecimaPlaces: 1;
		<<< '% min: ';
		<<< runTimes min;
		<<< 'us 1stQ: ';
		<<< runTimes quartiles first;
		<<< 'us ';
		<<< ' median: ';
		<<< runTimes quartiles second;
		<<< 'us ';
		<<< ' 3rdQ: ';
		<<< runTimes quartiles third;
		<<< 'us ';
		<<< ' max: ';
		<<< runTimes max;
		<<< 'us ';
		cr
]

{ #category : 'running' }
Benchmark >> runBenchmark [

	ScriptConsole println: 'Starting ' , name , ' benchmark ... ';flush.
	WorldMorph doOneCycle.

	self doRuns: benchmarkSuite new.
	self reportBenchmark.

	ScriptConsole println: ''
]

{ #category : 'calculating' }
Benchmark >> stdDev [

	^ (totalsq / numIterations - (total / numIterations) squared ) sqrt
]
