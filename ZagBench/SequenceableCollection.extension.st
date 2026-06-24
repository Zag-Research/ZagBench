Extension { #name : 'SequenceableCollection' }

{ #category : '*ZagBench' }
SequenceableCollection >> fkPermutationsDo: aBlock [
	"Repeatly value aBlock with a single copy of the receiver. Reorder the copy
	so that aBlock is presented all (self size factorial) possible permutations."

	"(Array streamContents: [:stream | (1 to: 3) fkPermutationsDo: [:each | stream nextPut: each copy]]) >>> #((1 2 3) (2 1 3) (2 3 1) (3 2 1) (3 1 2) (1 3 2))"

	"Iterate through all permutations of the receiver using the rotational shift 
	 mechanism from the Fannkuch-Redux algorithm, evaluating aBlock for each."
	
	| n perm1 count r keepShifting perm0 |
	n := self size.
	perm1 := self copy asArray.
	count := Array new: n.
	r := n.

	[ true ] whileTrue: [
		"Initialize the rotation counts for the current sub-arrays"
		[ r > 1 ] whileTrue: [
			count at: r put: r.
			r := r - 1.
		].

		"Yield a copy of the current permutation state to the block"
		aBlock value: perm1 copy.

		"Rotational shift loop"
		keepShifting := true.
		[ keepShifting ] whileTrue: [
			"Handling Zig's 'break :loop': Return directly from the method to terminate"
			r = n ifTrue: [ ^ self ].

			"Rotate the first r + 1 elements left"
			perm0 := perm1 at: 1.
			perm1 replaceFrom: 1 to: r with: perm1 startingAt: 2.
			perm1 at: r + 1 put: perm0.

			"Decrement rotation count for this position"
			count at: r + 1 put: (count at: r + 1) - 1.

			"Handling Zig's inner loop 'break': "
			(count at: r + 1) > 0
				ifTrue: [ keepShifting := false ] "Break out of the shift loop"
				ifFalse: [ r := r + 1 ].		 "Continue shifting with incremented r"
		].
	]
]
