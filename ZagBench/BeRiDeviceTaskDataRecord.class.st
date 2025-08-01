Class {
	#name : 'BeRiDeviceTaskDataRecord',
	#superclass : 'BeRiObject',
	#instVars : [
		'pending'
	],
	#category : 'ZagBench-Richards',
	#package : 'ZagBench',
	#tag : 'Richards'
}

{ #category : 'instance creation' }
BeRiDeviceTaskDataRecord class >> create [
    ^super new create
]

{ #category : 'initialize' }
BeRiDeviceTaskDataRecord >> create [
    pending := nil
]

{ #category : 'accessing' }
BeRiDeviceTaskDataRecord >> pending [
    ^pending
]

{ #category : 'accessing' }
BeRiDeviceTaskDataRecord >> pending: packet [ 
    pending := packet
]
