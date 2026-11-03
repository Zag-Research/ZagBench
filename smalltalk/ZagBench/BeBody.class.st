"
The Computer Language Benchmarks Game
  http://benchmarksgame.alioth.debian.org/

  contributed by Mark C. Lewis
  modified slightly by Chad Whipkey
  
  Based on nbody.java ported to SOM by Stefan Marr.
  See LICENSE.md file.
"
Class {
	#name : 'BeBody',
	#superclass : 'Object',
	#instVars : [
		'x',
		'y',
		'z',
		'vx',
		'vy',
		'vz',
		'mass'
	],
	#classInstVars : [
		'solarMass'
	],
	#category : 'ZagBench-NBody',
	#package : 'ZagBench',
	#tag : 'NBody'
}

{ #category : 'as yet unclassified' }
BeBody class >> DaysPerYear [

	^ 365.24
]

{ #category : 'as yet unclassified' }
BeBody class >> Pi [

	^ 3.141592653589793
]

{ #category : 'as yet unclassified' }
BeBody class >> SolarMass [

	^ solarMass
]

{ #category : 'as yet unclassified' }
BeBody class >> initialize [

	solarMass := 4 * self Pi * self Pi
]

{ #category : 'as yet unclassified' }
BeBody class >> jupiter [

     ^ self new
         initX:    4.8414314424647209
             y:   -1.16032004402742839
             z:   -0.103622044471123109
             vx:   0.00166007664274403694
             vy:   0.00769901118419740425
             vz:  -0.0000690460016972063023
             mass: 0.000954791938424326609

]

{ #category : 'as yet unclassified' }
BeBody class >> neptune [
    ^ self new
        initX:   15.3796971148509165
            y:  -25.9193146099879641
            z:    0.179258772950371181
            vx:   0.00268067772490389322
            vy:   0.00162824170038242295
            vz:  -0.000095159225451971587
            mass: 0.0000515138902046611451
]

{ #category : 'as yet unclassified' }
BeBody class >> saturn [
    ^ self new
        initX:    8.34336671824457987
            y:    4.12479856412430479
            z:   -0.403523417114321381
            vx:  -0.00276742510726862411
            vy:   0.00499852801234917238
            vz:   0.0000230417297573763929
            mass: 0.000285885980666130812

]

{ #category : 'as yet unclassified' }
BeBody class >> sun [
    ^ self new initX: 0.0 y: 0.0 z: 0.0 vx: 0.0 vy: 0.0 vz: 0.0 mass: 1.0
]

{ #category : 'as yet unclassified' }
BeBody class >> uranus [
    ^ self new
        initX:   12.894369562139131
            y:  -15.1111514016986312
            z:   -0.223307578892655734
            vx:   0.00296460137564761618
            vy:   0.0023784717395948095
            vz:  -0.0000296589568540237556
            mass: 0.0000436624404335156298

]

{ #category : 'as yet unclassified' }
BeBody >> initX: anX y: aY z: aZ vx: aVX vy: aVY vz: aVZ mass: aMass [
    x := anX.
    y := aY.
    z := aZ.
    vx := aVX * BeBody DaysPerYear.
    vy := aVY * BeBody DaysPerYear.
    vz := aVZ * BeBody DaysPerYear.
    mass := aMass * BeBody SolarMass
]

{ #category : 'accessing' }
BeBody >> mass [

	^ mass
]

{ #category : 'accessing' }
BeBody >> mass: anObject [

	mass := anObject
]

{ #category : 'as yet unclassified' }
BeBody >> offsetMomentumX: px y: py z: pz [
    vx := 0.0 - (px / BeBody SolarMass).
    vy := 0.0 - (py / BeBody SolarMass).
    vz := 0.0 - (pz / BeBody SolarMass)
]

{ #category : 'printing' }
BeBody >> print [
    'x:  ' print. x println.
    'y:  ' print. y println.
    'z:  ' print. z println.
    
    'vx: ' print. vx println.
    'vy: ' print. vy println.
    'vz: ' print. vz println.
    
    'mass: ' print. mass println
]

{ #category : 'accessing' }
BeBody >> vx [

	^ vx
]

{ #category : 'accessing' }
BeBody >> vx: anObject [

	vx := anObject
]

{ #category : 'accessing' }
BeBody >> vy [

	^ vy
]

{ #category : 'accessing' }
BeBody >> vy: anObject [

	vy := anObject
]

{ #category : 'accessing' }
BeBody >> vz [

	^ vz
]

{ #category : 'accessing' }
BeBody >> vz: anObject [

	vz := anObject
]

{ #category : 'accessing' }
BeBody >> x [

	^ x
]

{ #category : 'accessing' }
BeBody >> x: anObject [

	x := anObject
]

{ #category : 'accessing' }
BeBody >> y [

	^ y
]

{ #category : 'accessing' }
BeBody >> y: anObject [

	y := anObject
]

{ #category : 'accessing' }
BeBody >> z [

	^ z
]

{ #category : 'accessing' }
BeBody >> z: anObject [

	z := anObject
]
