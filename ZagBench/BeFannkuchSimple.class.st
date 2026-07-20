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
    perm  := Array new: n.

    "count[i] = i for i >= 2 (1-based)"
    count := Array new: n withAll: 0.
    2 to: n do: [:i | count at: i put: i ].

    maxFlips := 0.
    checksum := 0.
    permCount := 0.
    r := n.

    [ true ] whileTrue: [

        "Copy perm1 into working array"
        1 to: n do: [:i | perm at: i put: (perm1 at: i) ].

        "Count flips"
        flips := 0.
        [ (k := perm at: 1) ~= 1 ] whileTrue: [
            1 to: k // 2 do: [:i |
                | j temp |
                j := k - i + 1.
                temp := perm at: i.
                perm at: i put: (perm at: j).
                perm at: j put: temp ].
            flips := flips + 1 ].

        "Accumulate checksum"
        permCount even
            ifTrue:  [ checksum := checksum + flips ]
            ifFalse: [ checksum := checksum - flips ].

        "Track max flips"
        maxFlips := maxFlips max: flips.

        "Generate next permutation in canonical fannkuch order"
        r := n.
        [ r > 1 and: [ (count at: r) = 1 ] ] whileTrue: [
            count at: r put: r.
            r := r - 1 ].

        r = 1 ifTrue: [ ^ { checksum . maxFlips } ].

        count at: r put: (count at: r) - 1.

        "Rotate first r elements left by one"
        first := perm1 at: 1.
        1 to: r - 1 do: [:i |
            perm1 at: i put: (perm1 at: i + 1) ].
        perm1 at: r put: first.

        permCount := permCount + 1
    ].

]
