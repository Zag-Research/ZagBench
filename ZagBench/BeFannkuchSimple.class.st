Class {
	#name : 'BeFannkuchSimple',
	#superclass : 'Object',
	#category : 'ZagBench-FannkuchSimple',
	#package : 'ZagBench',
	#tag : 'FannkuchSimple'
}

{ #category : 'benchmarking' }
BeFannkuchSimple >> fannkuch: n [
    | perm1 perm count maxFlips permCount checksum r flips k foundNext |
    perm1 := (1 to: n) asArray.
    perm  := Array new: n.
    count := Array new: n + 1 withAll: 0.
    maxFlips  := 0.
    permCount := 0.
    checksum  := 0.
    r         := n.

    [ true ] whileTrue: [

        "Refill wheels that exhausted — only touches indices 2..n"
        [ r > 1 and: [ (count at: r) = 0 ] ] whileTrue: [
            count at: r put: r.
            r := r - 1
        ].

        "Copy perm1 into working array"
        1 to: n do: [ :i | perm at: i put: (perm1 at: i) ].

        "Count flips"
        flips := 0.
        [ (k := perm at: 1) ~= 1 ] whileTrue: [
            1 to: k // 2 do: [ :i |
                | temp j |
                j := k - i + 1.
                temp := perm at: i.
                perm at: i put: (perm at: j).
                perm at: j put: temp
            ].
            flips := flips + 1
        ].

        "Accumulate"
        maxFlips := maxFlips max: flips.
        permCount even
            ifTrue:  [ checksum := checksum + flips ]
            ifFalse: [ checksum := checksum - flips ].
        permCount := permCount + 1.

        "Generate next permutation"
        "r walks 1..n-1 only. count[r+1] touches indices 2..n which refill owns."
        r := 1.
        foundNext := false.
        [ r < n ] whileTrue: [
            | first |
            count at: r + 1 put: (count at: r + 1) - 1.
            (count at: r + 1) > 0
                ifTrue: [
                    first := perm1 at: 1.
                    1 to: r do: [ :i | perm1 at: i put: (perm1 at: i + 1) ].
                    perm1 at: r + 1 put: first.
                    foundNext := true.
                    r := n.    "n < n is false — exits loop"
                ]
                ifFalse: [ r := r + 1 ]
        ].

        foundNext ifFalse: [ ^ Array with: checksum with: maxFlips ].
    ]
]
