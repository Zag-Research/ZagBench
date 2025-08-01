"
Benchmark runner and superclass

All benchmarks should be subclasses of this.

Run a benchmark doing something like:

      `Benchmark` `NBody`
or
		`Benchmark` run: #NBody

It will create an instance of the benchmark and send it an `innerBenchmarkLoop:` message to run the benchmark.
The number of runs for that benchmark is the number returned by the class-side method `mainIterations`, which defaults to 10.
The number of iterations for that method to run is the number returned by the class-side method `innerIterations`, which defaults to 250,000.
A garbage collection is done before the first run, so depending on the benchmark, some variance may come from collection within individual runs.

Statistics of execution are printed on the `Transcript`, including mean, standard deviation, and several other usefull values.

All the values can be accessed from the run benchmark: `mean`, `stdDev`, `min`, `max`, `firstQuartile`, `median`, `thirdQuartile`, as well as the raw runtimes in `times`.

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
		'innerIterations',
		'totalsq',
		'logging',
		'times',
		'mainIterations',
		'random'
	],
	#classVars : [
		'ScriptConsole'
	],
	#category : 'ZagBench-Benchmarking',
	#package : 'ZagBench',
	#tag : 'Benchmarking'
}

{ #category : 'as yet unclassified' }
Benchmark class >> allBenchmarks [

	^ self instanceSide subclasses
]

{ #category : 'reflective operations' }
Benchmark class >> benchmark: aString [

	^ self new initialize: aString
]

{ #category : 'reflective operations' }
Benchmark class >> doesNotUnderstand: aMessage [

	(Smalltalk classNamed: aMessage selector) ifNil: [
		(Smalltalk classNamed: #Be, aMessage selector) ifNil: [
			^ super doesNotUnderstand: aMessage ]].
	^ self run: aMessage selector
]

{ #category : 'class initialization' }
Benchmark class >> initialize [

	ScriptConsole := Transcript
]

{ #category : 'benchmarking' }
Benchmark class >> innerIterations [

	^ 250000
]

{ #category : 'benchmarking' }
Benchmark class >> mainIterations [

	^ 10
]

{ #category : 'running' }
Benchmark class >> run [

	self == Benchmark ifTrue: [
		^ self allBenchmarks do: [ : benchmark | self run: benchmark name ] ].
	^ self run: name
]

{ #category : 'reflective operations' }
Benchmark class >> run: aString [

	^ (self benchmark: aString asSymbol) runBenchmark
]

{ #category : 'running' }
Benchmark >> doRuns: bench [
    1 to: mainIterations do: [:i |
      self measure: bench
    ]
]

{ #category : 'calculating' }
Benchmark >> firstQuartile [

	^ times quartiles first
]

{ #category : 'initialization' }
Benchmark >> initialize [

	super initialize.
	logging := false.
	random := BeRandom new
]

{ #category : 'initialization' }
Benchmark >> initialize: aName [

	name := aName.
	benchmarkSuite := self loadBenchmarkSuite: aName.
	total := 0.
	totalsq := 0.
	mainIterations := benchmarkSuite mainIterations.
	innerIterations := benchmarkSuite innerIterations.
	times := OrderedCollection new
]

{ #category : 'running' }
Benchmark >> innerBenchmarkLoop: unreferenced [

	^ self subclassResponsibility
]

{ #category : 'initialization' }
Benchmark >> loadBenchmarkSuite: className [

	| cls |
	cls := Smalltalk classNamed: className.
	cls ifNil: [
		cls := Smalltalk classNamed: (#Be, className).
		cls ifNil: [
			self error: 'Failed loading benchmark: ', className ] ].
	^ cls
]

{ #category : 'calculating' }
Benchmark >> max [

	^ times max
]

{ #category : 'calculating' }
Benchmark >> mean [

	^ total // mainIterations
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

	times add: runTime.
	totalsq := totalsq + (runTime * runTime).
	total := total + runTime
]

{ #category : 'calculating' }
Benchmark >> median [

	^ times quartiles second
]

{ #category : 'calculating' }
Benchmark >> min [

	^ times min
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

	ScriptConsole
		<< name;
		<< ': n=';
		<< mainIterations;
		<< ' mean: ';
		<< self mean;
		<< 'us stdDev: ';
		<< self stdDev asInteger;
		<< 'us (';
		<< (self stdDev / self mean * 100 printShowingDecimalPlaces: 1);
		<< '%) min: ';
		<< self min;
		<< 'us 1stQ: ';
		<< self firstQuartile;
		<< 'us ';
		<< ' median: ';
		<< self median;
		<< 'us ';
		<< ' 3rdQ: ';
		<< self thirdQuartile;
		<< 'us ';
		<< ' max: ';
		<< self max;
		<< 'us ';
		cr
]

{ #category : 'running' }
Benchmark >> runBenchmark [

	ScriptConsole
		<< 'Starting ' << name << ' benchmark ... ';cr;
		flush.
	WorldMorph doOneCycle.
	Smalltalk garbageCollect.

	self doRuns: benchmarkSuite new.
	self reportBenchmark.

	ScriptConsole cr
]

{ #category : 'calculating' }
Benchmark >> stdDev [

	^ (totalsq / mainIterations - (total / mainIterations) squared ) sqrt
]

{ #category : 'calculating' }
Benchmark >> thirdQuartile [

	^ times quartiles third
]

{ #category : 'accessing' }
Benchmark >> times [

	^ times asArray
]

{ #category : 'benchmarking' }
Benchmark >> verifyResult: result [

	^ self subclassResponsibility
]
