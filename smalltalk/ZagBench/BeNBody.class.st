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
	#name : 'BeNBody',
	#superclass : 'Benchmark',
	#category : 'ZagBench-NBody',
	#package : 'ZagBench',
	#tag : 'NBody'
}

{ #category : 'instance creation' }
BeNBody class >> new [

	BeBody initialize.
   ^ super new
]

{ #category : 'running' }
BeNBody >> innerBenchmarkLoop: iterations [

	| system |
	system := BeNBodySystem new.

	1 to: iterations do: [ :i | system advance: 0.01 ].

	^ self verify: system energy for: iterations
]

{ #category : 'as yet unclassified' }
BeNBody >> verify: result for: iterations [
	iterations = 250000 ifTrue: [ ^ result = -0.1690859889909308  ].
	iterations =      1 ifTrue: [ ^ result = -0.16907495402506745 ].

	ScriptConsole << 'No verification result for ' << iterations asString << ' found'; cr.
	ScriptConsole << 'Result is: ' << result asString; cr.
	^ false
]
