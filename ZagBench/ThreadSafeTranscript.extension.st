Extension { #name : 'ThreadSafeTranscript' }

{ #category : '*ZagBench' }
ThreadSafeTranscript >> <<< anObject [

	anObject printOrPutOn: self
]

{ #category : '*ZagBench' }
ThreadSafeTranscript >> print: aNumber withDecimaPlaces: anInteger [

	aNumber printOn: self showingDecimalPlaces: anInteger
]

{ #category : '*ZagBench' }
ThreadSafeTranscript >> println: aString [ 
	self show: aString;cr
]
