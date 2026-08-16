"
I am a strange list that is built up of contexts and blocks
"
Class {
	#name : 'BeResilientList',
	#superclass : 'Object',
	#instVars : [
		'next'
	],
	#category : 'ZagBench-ResilientBlocks',
	#package : 'ZagBench',
	#tag : 'ResilientBlocks'
}

{ #category : 'instance creation' }
BeResilientList class >> new: size [
	" self new: 5 "

	^ self new build: size
]

{ #category : 'instance creation' }
BeResilientList >> build: size [

	^ self build: size from: nil
]

{ #category : 'instance creation' }
BeResilientList >> build: size from: other [

	next := other.
	size <= 1 ifTrue: [ ^ self ].
	^ self class new build: size - 1 from: self
]

{ #category : 'accessing' }
BeResilientList >> do: block [

    block value: self.
    next do: block.
]

{ #category : 'accessing' }
BeResilientList >> ifLast: block [

	next ifNil: [ block value ]
]

{ #category : 'accessing' }
BeResilientList >> size [

	| n |
	n := 0.
	self do: [ :e | n := n + 1. e ifLast: [ ^ n ]. ]
]
