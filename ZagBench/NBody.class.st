"
The Computer Language Benchmarks Game
  http://shootout.alioth.debian.org/

  contributed by Mark C. Lewis
  modified slightly by Chad Whipkey
  
  Based on nbody.java ported to SOM by Stefan Marr.
  See LICENSE.md file.

Ported from SOM at https://github.com/smarr/are-we-fast-yet/tree/master
"
Class {
	#name : 'NBody',
	#superclass : 'Benchmark',
	#category : 'ZagBench-NBody',
	#package : 'ZagBench',
	#tag : 'NBody'
}

{ #category : 'instance creation' }
NBody class >> new [

	Body initialize.
   ^ super new
]

{ #category : 'running' }
NBody >> innerBenchmarkLoop: iterations [

	| system |
	system := NBodySystem new.

	1 to: iterations do: [ :i | system advance: 0.01 ].

	^ self verify: system energy for: iterations
]

{ #category : 'as yet unclassified' }
NBody >> verify: result for: innerIterations [
    innerIterations = 250000 ifTrue: [ ^ result = -0.1690859889909308  ].
    innerIterations =      1 ifTrue: [ ^ result = -0.16907495402506745 ].

    ('No verification result for ', innerIterations asString, ' found') println.
    ('Result is: ', result asString) println.
    ^ false
]
