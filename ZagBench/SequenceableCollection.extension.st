Extension { #name : 'SequenceableCollection' }

{ #category : '*ZagBench' }
SequenceableCollection >> permutationsIteratedDo: aBlock [
	"Repeatly value aBlock with a single copy of the receiver. Reorder the copy
	so that aBlock is presented all (self size factorial) possible permutations.
	
	The same as `permutationsDo:` except iterated using the rotational shift 
	mechanism from the Fannkuch-Redux algorithm rather than the recursive algorithm.
	All the same permutations are presented, but in a different order."

	"(Array streamContents: [:stream | (1 to: 3) fkPermutationsDo: [:each | stream nextPut: each copy]]) >>> #((1 2 3) (2 1 3) (2 3 1) (3 2 1) (3 1 2) (1 3 2))"

	| n perm count r keepShifting temp |
	n := self size.
	perm := self copy asArray.
	count := Array new: n.
	r := n.

	[ true ] whileTrue: [
			[ r > 1 ] whileTrue: [
					count at: r put: r.
					r := r - 1 ].
			aBlock value: perm.
			keepShifting := true.
			[ keepShifting ] whileTrue: [
					r = n ifTrue: [ ^ self ].
					temp := perm at: 1.
					perm
						replaceFrom: 1
						to: r
						with: perm
						startingAt: 2.
					perm at: r + 1 put: temp.
					count at: r + 1 put: (count at: r + 1) - 1.
					(count at: r + 1) > 0
						ifTrue: [ keepShifting := false ]
						ifFalse: [ r := r + 1 ] ] ]
]
