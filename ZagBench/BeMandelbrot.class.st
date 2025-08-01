"
I implement a Mandelbrot benchmark

I test floating point operations (mostly addition and multiplications, with a few divisions) with a triply-nested loop.

Derived from https://github.com/smarr/are-we-fast-yet/blob/master/benchmarks/Smalltalk/Mandelbrot.som
"
Class {
	#name : 'BeMandelbrot',
	#superclass : 'Benchmark',
	#category : 'ZagBench-Mandelbrot',
	#package : 'ZagBench',
	#tag : 'Mandelbrot'
}

{ #category : 'benchmarking' }
BeMandelbrot class >> innerIterations [

	^ 466
]

{ #category : 'controlling' }
BeMandelbrot >> innerBenchmarkLoop: iterations [

	^ self
		  verify: (self mandelbrot: iterations)
		  inner: iterations
]

{ #category : 'benchmarking' }
BeMandelbrot >> mandelbrot: size [

	| sum byteAcc bitNum y |
	sum := 0.
	byteAcc := 0.
	bitNum := 0.

	y := 0.

	[ y < size ] whileTrue: [
		| ci x |
		ci := 2.0 * y / size - 1.0.
		x := 0.

		[ x < size ] whileTrue: [
			| zrzr zi zizi cr escape z notDone |
			zrzr := 0.0.
			zizi := zi := 0.0.
			cr := 2.0 * x / size - 1.5.

			z := 0.
			notDone := true.
			escape := 0.
			[ notDone and: [ z < 50 ] ] whileTrue: [
				| zr |
				zr := zrzr - zizi + cr.
				zi := 2.0 * zr * zi + ci.

				"preserve recalculation"
				zrzr := zr * zr.
				zizi := zi * zi.

				zrzr + zizi > 4.0 ifTrue: [
					notDone := false.
					escape := 1 ].
				z := z + 1 ].

			byteAcc := byteAcc << 1 + escape.
			bitNum := bitNum + 1.

			" Code is very similar for these cases, but using separate blocks
                ensures we skip the shifting when it's unnecessary,
                which is most cases. "
			bitNum = 8
				ifTrue: [
					sum := sum bitXor: byteAcc.
					byteAcc := 0.
					bitNum := 0 ]
				ifFalse: [
					x = (size - 1) ifTrue: [
						byteAcc := byteAcc << (8 - bitNum).
						sum := sum bitXor: byteAcc.
						byteAcc := 0.
						bitNum := 0 ] ].
			x := x + 1 ].
		y := y + 1 ].

	^ sum
]

{ #category : 'verification' }
BeMandelbrot >> verify: result inner: iterations [

	iterations = 325 ifTrue: [ ^ result = 248 ].
	iterations = 450 ifTrue: [ ^ result = 13 ].
	iterations = 466 ifTrue: [ ^ result = 253 ].
	iterations = 475 ifTrue: [ ^ result = 191 ].
	iterations = 500 ifTrue: [ ^ result = 191 ].
	iterations = 750 ifTrue: [ ^ result = 50 ].
	iterations = 1000 ifTrue: [ ^ result = 101 ].
	iterations = 2500 ifTrue: [ ^ result = 231 ].
	iterations = 1 ifTrue: [ ^ result = 128 ].

	ScriptConsole 
		<< 'No verification result for ';
		<< iterations asString;
		<< ' found';
		cr.
	ScriptConsole
		<< 'Result is: ';
		<< result asString;
		cr.
	^ false
]
