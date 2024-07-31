"
The Computer Language Benchmarks Game
  http://benchmarksgame.alioth.debian.org/

  contributed by Mark C. Lewis
  modified slightly by Chad Whipkey
  
  Based on nbody.java ported to SOM by Stefan Marr.
  See LICENSE.md file.
"
Class {
	#name : 'Body',
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
Body class >> DaysPerYear [

	^ 365.24
]

{ #category : 'as yet unclassified' }
Body class >> Pi [

	^ 3.141592653589793
]

{ #category : 'as yet unclassified' }
Body class >> SolarMass [

	^ solarMass
]

{ #category : 'as yet unclassified' }
Body class >> initialize [

	solarMass := 4 * self Pi * self Pi
]

{ #category : 'as yet unclassified' }
Body class >> jupiter [

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
Body class >> neptune [
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
Body class >> saturn [
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
Body class >> sun [
    ^ self new initX: 0.0 y: 0.0 z: 0.0 vx: 0.0 vy: 0.0 vz: 0.0 mass: 1.0
]

{ #category : 'as yet unclassified' }
Body class >> uranus [
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
Body >> initX: anX y: aY z: aZ vx: aVX vy: aVY vz: aVZ mass: aMass [
    x := anX.
    y := aY.
    z := aZ.
    vx := aVX * Body DaysPerYear.
    vy := aVY * Body DaysPerYear.
    vz := aVZ * Body DaysPerYear.
    mass := aMass * Body SolarMass
]

{ #category : 'accessing' }
Body >> mass [

	^ mass
]

{ #category : 'accessing' }
Body >> mass: anObject [

	mass := anObject
]

{ #category : 'as yet unclassified' }
Body >> offsetMomentumX: px y: py z: pz [
    vx := 0.0 - (px / Body SolarMass).
    vy := 0.0 - (py / Body SolarMass).
    vz := 0.0 - (pz / Body SolarMass)
]

{ #category : 'printing' }
Body >> print [
    'x:  ' print. x println.
    'y:  ' print. y println.
    'z:  ' print. z println.
    
    'vx: ' print. vx println.
    'vy: ' print. vy println.
    'vz: ' print. vz println.
    
    'mass: ' print. mass println
]

{ #category : 'accessing' }
Body >> vx [

	^ vx
]

{ #category : 'accessing' }
Body >> vx: anObject [

	vx := anObject
]

{ #category : 'accessing' }
Body >> vy [

	^ vy
]

{ #category : 'accessing' }
Body >> vy: anObject [

	vy := anObject
]

{ #category : 'accessing' }
Body >> vz [

	^ vz
]

{ #category : 'accessing' }
Body >> vz: anObject [

	vz := anObject
]

{ #category : 'accessing' }
Body >> x [

	^ x
]

{ #category : 'accessing' }
Body >> x: anObject [

	x := anObject
]

{ #category : 'accessing' }
Body >> y [

	^ y
]

{ #category : 'accessing' }
Body >> y: anObject [

	y := anObject
]

{ #category : 'accessing' }
Body >> z [

	^ z
]

{ #category : 'accessing' }
Body >> z: anObject [

	z := anObject
]
