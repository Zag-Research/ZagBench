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
ManifestZagBench class >> ruleClassNotReferencedRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGPackageDefinition #(#ZagBench)) #'2024-09-10T15:18:28.185408-04:00') )
]

{ #category : 'code-critics' }
ManifestZagBench class >> ruleLongMethodsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGPackageDefinition #(#ZagBench)) #'2024-07-31T13:53:20.583848-04:00') )
]

{ #category : 'code-critics' }
ManifestZagBench class >> ruleReCyclomaticComplexityRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #( #( #( #RGPackageDefinition #( #ZagBench ) )
	        #'2024-09-10T15:01:12.769636-04:00' ) )
]

{ #category : 'code-critics' }
ManifestZagBench class >> ruleRefersToClassRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#'Benchmark class' #run #true)) #'2024-08-01T09:49:37.471071-04:00') )
]

{ #category : 'code-critics' }
ManifestZagBench class >> ruleWhileTrueRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #( #( #( #RGPackageDefinition #( #ZagBench ) )
	        #'2024-09-10T15:01:22.027308-04:00' ) )
]
