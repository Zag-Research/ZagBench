Class {
	#name : 'BeFannkuchSimple',
	#superclass : 'Object',
	#category : 'ZagBench-FannkuchSimple',
	#package : 'ZagBench',
	#tag : 'FannkuchSimple'
}

{ #category : 'benchmarking' }
BeFannkuchSimple >> fannkuch: n [

	| perm1 perm count maxFlips checksum permCount r flips k first |
	"Initial permutation 1..n"
	perm1 := (1 to: n) asArray.
	perm := Array new: n.

	"count[i] = i for i >= 2 (1-based)"
	count := Array new: n withAll: 0.
	2 to: n do: [ :i | count at: i put: i ].

	maxFlips := 0.
	checksum := 0.
	permCount := 0.
	r := n.

	[ true ] whileTrue: [ "Copy perm1 into working array"
			1 to: n do: [ :i | perm at: i put: (perm1 at: i) ].

			"Count flips"
			flips := 0.
			[ (k := perm at: 1) ~= 1 ] whileTrue: [
					1 to: k // 2 do: [ :i |
							| j temp |
							j := k - i + 1.
							temp := perm at: i.
							perm at: i put: (perm at: j).
							perm at: j put: temp ].
					flips := flips + 1 ].

			"Accumulate checksum"
			checksum := permCount even
				            ifTrue: [ checksum + flips ]
				            ifFalse: [ checksum - flips ].
			maxFlips := maxFlips max: flips.

			"Generate next permutation in canonical fannkuch order"
			r := n.
			[ r > 1 and: [ (count at: r) = 1 ] ] whileTrue: [
					count at: r put: r.
					r := r - 1 ].

			r = 1 ifTrue: [
					^ {
						  checksum.
						  maxFlips } ].

			count at: r put: (count at: r) - 1.

			"Rotate first r elements left by one"
			first := perm1 at: 1.
			1 to: r - 1 do: [ :i | perm1 at: i put: (perm1 at: i + 1) ].
			perm1 at: r put: first.

			permCount := permCount + 1 ]
]

{ #category : 'benchmarking' }
BeFannkuchSimple >> solve: n [

	| maxCount checkSum flips toFlip permCount array |
	maxCount := 0.
	checkSum := 0.
	permCount := 0.
	(1 to: n) fkPermutationsDo: [ : permutation|
		permutation first ~= 1 ifTrue: [
			array := permutation copy.
			flips := 0.
			[ (toFlip := array at: 1) = 1 ] whileFalse: [
				"self halt."
				flips := flips + 1.
				1 to: toFlip // 2 do: [ : i | |temp target|
					target := toFlip - i + 1.
					temp := array at: i.
					array at: i put: (array at: target).
					array at: target put: temp
				]
			].
			maxCount := maxCount max: flips.
			checkSum := checkSum + (permCount even ifTrue: [flips] ifFalse: [flips negated] )
		].
		permCount := permCount + 1.
	].
	^ {checkSum . maxCount}
]
