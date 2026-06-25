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
ManifestZagBench class >> ruleClassNameInSelectorRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#'Benchmark class' #allBenchmarks #true)) #'2026-06-25T08:01:53.027236-04:00') )
]

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
ManifestZagBench class >> ruleReCollectionAtCollectionSizeRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#SequenceableCollection #permutationsIteratedDo: #false)) #'2026-06-24T17:52:04.992888-04:00') #(#(#RGMethodDefinition #(#BeFannkuch #solve: #false)) #'2026-06-25T07:52:42.400014-04:00') )
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
ManifestZagBench class >> ruleUnclassifiedMethodsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#'BeFannkuchSimple class' #fannkuch: #true)) #'2026-04-09T20:07:50.034221-04:00') )
]

{ #category : 'code-critics' }
ManifestZagBench class >> ruleWhileTrueRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #( #( #( #RGPackageDefinition #( #ZagBench ) )
	        #'2024-09-10T15:01:22.027308-04:00' ) )
]
