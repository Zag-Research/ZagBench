"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestZagBench',
	#superclass : 'PackageManifest',
	#category : 'ZagBench-Manifest',
	#package : 'ZagBench',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestZagBench class >> ruleLongMethodsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGPackageDefinition #(#ZagBench)) #'2024-07-31T13:53:20.583848-04:00') )
]
