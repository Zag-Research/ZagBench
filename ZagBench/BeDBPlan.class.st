"
A Plan is an ordered list of constraints to be executed in sequence to
resatisfy all currently satisfiable constraints in the face of one or more
changing inputs.
"
Class {
	#name : 'BeDBPlan',
	#superclass : 'OrderedCollection',
	#type : 'variable',
	#category : 'ZagBench-DeltaBlue',
	#package : 'ZagBench',
	#tag : 'DeltaBlue'
}

{ #category : 'execution' }
BeDBPlan >> execute [
	"Execute my constraints in order."

	self do: [: c | c execute].
]
