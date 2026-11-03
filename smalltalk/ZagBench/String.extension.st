Extension { #name : 'String' }

{ #category : '*ZagBench' }
String >> printOrPutOn: aStream [

	aStream nextPutAll: self
]
