"Consolidated Richards benchmark code with source file names"

"===== FILE: BeRiDeviceTaskDataRecord.class.st ====="
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


"===== FILE: BeRiHandlerTaskDataRecord.class.st ====="
Class {
	#name : 'BeRiHandlerTaskDataRecord',
	#superclass : 'BeRiObject',
	#instVars : [
		'workIn',
		'deviceIn'
	],
	#category : 'ZagBench-Richards',
	#package : 'ZagBench',
	#tag : 'Richards'
}

{ #category : 'instance creation' }
BeRiHandlerTaskDataRecord class >> create [
    ^super new create
]

{ #category : 'initialize' }
BeRiHandlerTaskDataRecord >> create [
    workIn := deviceIn := nil
]

{ #category : 'accessing' }
BeRiHandlerTaskDataRecord >> deviceIn [
    ^deviceIn
]

{ #category : 'accessing' }
BeRiHandlerTaskDataRecord >> deviceIn: aPacket [
    deviceIn := aPacket
]

{ #category : 'accessing' }
BeRiHandlerTaskDataRecord >> deviceInAdd: packet [
    deviceIn := self append: packet head: deviceIn
]

{ #category : 'accessing' }
BeRiHandlerTaskDataRecord >> workIn [
    ^workIn
]

{ #category : 'accessing' }
BeRiHandlerTaskDataRecord >> workIn: aWorkQueue [ 
    workIn := aWorkQueue
]

{ #category : 'accessing' }
BeRiHandlerTaskDataRecord >> workInAdd: packet [
    workIn := self append: packet head: workIn
]


"===== FILE: BeRiIdleTaskDataRecord.class.st ====="
Class {
	#name : 'BeRiIdleTaskDataRecord',
	#superclass : 'BeRiObject',
	#instVars : [
		'control',
		'count'
	],
	#category : 'ZagBench-Richards',
	#package : 'ZagBench',
	#tag : 'Richards'
}

{ #category : 'instance creation' }
BeRiIdleTaskDataRecord class >> create [
    ^super new create
]

{ #category : 'accessing' }
BeRiIdleTaskDataRecord >> control [
    ^control
]

{ #category : 'accessing' }
BeRiIdleTaskDataRecord >> control: aNumber [
    control := aNumber
]

{ #category : 'accessing' }
BeRiIdleTaskDataRecord >> count [
    ^count
]

{ #category : 'accessing' }
BeRiIdleTaskDataRecord >> count: aCount [
    count := aCount
]

{ #category : 'initialize' }
BeRiIdleTaskDataRecord >> create [
    control := 1.
    count := 10000
]


"===== FILE: BeRiObject.class.st ====="
Class {
	#name : 'BeRiObject',
	#superclass : 'Object',
	#classVars : [
		'DeviceA',
		'DeviceB',
		'DevicePacketKind',
		'HandlerA',
		'HandlerB',
		'Idler',
		'WorkPacketKind',
		'Worker'
	],
	#category : 'ZagBench-Richards',
	#package : 'ZagBench',
	#tag : 'Richards'
}

{ #category : 'initialize' }
BeRiObject class >> initialize [
    "BeRiObject initialize"
    DeviceA := 5.
    DeviceB := 6.
    DevicePacketKind := 1.
    HandlerA := 3.
    HandlerB := 4.
    Idler := 1.
    Worker := 2.
    WorkPacketKind := 2
]

{ #category : 'utilities' }
BeRiObject >> append: packet head: queueHead [
    | mouse link |
    packet link: nil.
    queueHead isNil ifTrue: [^packet].
    mouse := queueHead.
    [(link := mouse link) isNil]
	whileFalse: [mouse := link].
    mouse link: packet.
    ^queueHead
]


"===== FILE: BeRiPacket.class.st ====="
Class {
	#name : 'BeRiPacket',
	#superclass : 'BeRiObject',
	#instVars : [
		'link',
		'identity',
		'kind',
		'datum',
		'data'
	],
	#category : 'ZagBench-Richards',
	#package : 'ZagBench',
	#tag : 'Richards'
}

{ #category : 'instance creation' }
BeRiPacket class >> create: link identity: identity kind: kind [ 
    ^super new
	link: link
	identity: identity
	kind: kind
]

{ #category : 'accessing' }
BeRiPacket >> data [
    ^data
]

{ #category : 'accessing' }
BeRiPacket >> datum [
    ^datum
]

{ #category : 'accessing' }
BeRiPacket >> datum:    someData [
    datum := someData
]

{ #category : 'accessing' }
BeRiPacket >> identity [
    ^identity
]

{ #category : 'accessing' }
BeRiPacket >> identity: anIdentity [
    identity := anIdentity
]

{ #category : 'accessing' }
BeRiPacket >> kind [
    ^kind
]

{ #category : 'accessing' }
BeRiPacket >> link [
    ^link
]

{ #category : 'accessing' }
BeRiPacket >> link: aWorkQueue [ 
    link := aWorkQueue
]

{ #category : 'initialize' }
BeRiPacket >> link: aLink identity: anIdentity kind: aKind [ 
    link := aLink.
    identity := anIdentity. 
    kind := aKind.
    datum := 1.
    data := ByteArray new: 4
]


"===== FILE: BeRiTaskControlBlock.class.st ====="
Class {
	#name : 'BeRiTaskControlBlock',
	#superclass : 'BeRiTaskState',
	#instVars : [
		'link',
		'identity',
		'priority',
		'input',
		'state',
		'function',
		'handle'
	],
	#category : 'ZagBench-Richards',
	#package : 'ZagBench',
	#tag : 'Richards'
}

{ #category : 'instance creation' }
BeRiTaskControlBlock class >> link: link create: identity priority: priority initialWorkQueue: initialWorkQueue initialState: initialState function: aBlock privateData: privateData [ 
    ^super new
	link: link
	identity: identity
	priority: priority
	initialWorkQueue: initialWorkQueue
	initialState: initialState
	function: aBlock
	privateData: privateData
]

{ #category : 'scheduling' }
BeRiTaskControlBlock >> addInput: packet checkPriority: oldTask [
    input isNil
	ifTrue: 
	    [input := packet.
	    packetPendingIV := true.
	    priority > oldTask priority ifTrue: [^self]]
	ifFalse: 
	    [input := self append: packet head: input].
    ^oldTask
]

{ #category : 'accessing' }
BeRiTaskControlBlock >> identity [
    ^identity
]

{ #category : 'accessing' }
BeRiTaskControlBlock >> link [
    ^link
]

{ #category : 'initialize' }
BeRiTaskControlBlock >> link: aLink identity: anIdentity priority: aPriority initialWorkQueue: anInitialWorkQueue initialState: anInitialState function: aBlock privateData: aPrivateData [ 
    link := aLink.
    identity := anIdentity.
    priority := aPriority.
    input := anInitialWorkQueue.
    packetPendingIV := anInitialState isPacketPending.
    taskWaiting := anInitialState isTaskWaiting.
    taskHolding := anInitialState isTaskHolding.
    function := aBlock.
    handle := aPrivateData
]

{ #category : 'accessing' }
BeRiTaskControlBlock >> priority [
    ^priority
]

{ #category : 'scheduling' }
BeRiTaskControlBlock >> runTask [
    | message |
    self isWaitingWithPacket
	ifTrue: 
	    [message := input.
	    input := message link.
	    input isNil
		ifTrue: [self running]
		ifFalse: [self packetPending]]
	ifFalse: [message := nil].
    ^function value: message value: handle
]


"===== FILE: BeRiTaskState.class.st ====="
Class {
	#name : 'BeRiTaskState',
	#superclass : 'BeRiObject',
	#instVars : [
		'packetPendingIV',
		'taskWaiting',
		'taskHolding'
	],
	#category : 'ZagBench-Richards',
	#package : 'ZagBench',
	#tag : 'Richards'
}

{ #category : 'instance creation' }
BeRiTaskState class >> packetPending [
    ^super new packetPending
]

{ #category : 'instance creation' }
BeRiTaskState class >> running [
    ^super new running
]

{ #category : 'instance creation' }
BeRiTaskState class >> waiting [
    ^super new waiting
]

{ #category : 'instance creation' }
BeRiTaskState class >> waitingWithPacket [
    ^super new waitingWithPacket
]

{ #category : 'accessing' }
BeRiTaskState >> isPacketPending [
    ^packetPendingIV
]

{ #category : 'testing' }
BeRiTaskState >> isRunning [
    ^packetPendingIV not and: [taskWaiting not and: [taskHolding not]]
]

{ #category : 'accessing' }
BeRiTaskState >> isTaskHolding [
    ^taskHolding
]

{ #category : 'testing' }
BeRiTaskState >> isTaskHoldingOrWaiting [
    ^taskHolding or: [packetPendingIV not and: [taskWaiting]]
]

{ #category : 'accessing' }
BeRiTaskState >> isTaskWaiting [
    ^taskWaiting
]

{ #category : 'testing' }
BeRiTaskState >> isWaiting [
    ^packetPendingIV not and: [taskWaiting and: [taskHolding not]]
]

{ #category : 'testing' }
BeRiTaskState >> isWaitingWithPacket [
    ^packetPendingIV and: [taskWaiting and: [taskHolding not]]
]

{ #category : 'initialize' }
BeRiTaskState >> packetPending [
    packetPendingIV := true.
    taskWaiting := false.
    taskHolding := false
]

{ #category : 'initialize' }
BeRiTaskState >> running [
    packetPendingIV := taskWaiting := taskHolding := false
]

{ #category : 'accessing' }
BeRiTaskState >> taskHolding: aBoolean [
    taskHolding := aBoolean
]

{ #category : 'accessing' }
BeRiTaskState >> taskWaiting: aBoolean [ 
    taskWaiting := aBoolean
]

{ #category : 'initialize' }
BeRiTaskState >> waiting [
    packetPendingIV := taskHolding := false.
    taskWaiting := true
]

{ #category : 'initialize' }
BeRiTaskState >> waitingWithPacket [
    taskHolding := false.
    taskWaiting := packetPendingIV := true
]


"===== FILE: BeRiWorkerTaskDataRecord.class.st ====="
Class {
	#name : 'BeRiWorkerTaskDataRecord',
	#superclass : 'BeRiObject',
	#instVars : [
		'destination',
		'count'
	],
	#category : 'ZagBench-Richards',
	#package : 'ZagBench',
	#tag : 'Richards'
}

{ #category : 'instance creation' }
BeRiWorkerTaskDataRecord class >> create [
    ^super new create
]

{ #category : 'accessing' }
BeRiWorkerTaskDataRecord >> count [
    ^count
]

{ #category : 'accessing' }
BeRiWorkerTaskDataRecord >> count: aCount [
    count := aCount
]

{ #category : 'initialize' }
BeRiWorkerTaskDataRecord >> create [
    destination := HandlerA.
    count := 0
]

{ #category : 'accessing' }
BeRiWorkerTaskDataRecord >> destination [
    ^destination
]

{ #category : 'accessing' }
BeRiWorkerTaskDataRecord >> destination: aHandler [
    destination := aHandler
]


"===== FILE: BeRichardsBenchmark.class.st ====="
"
I implement the Richards scheduling benchmark
"
Class {
	#name : 'BeRichardsBenchmark',
	#superclass : 'BeRiObject',
	#instVars : [
		'taskList',
		'currentTask',
		'currentTaskIdentity',
		'taskTable',
		'tracing',
		'layout',
		'queuePacketCount',
		'holdCount'
	],
	#category : 'ZagBench-Richards',
	#package : 'ZagBench',
	#tag : 'Richards'
}

{ #category : 'instance creation' }
BeRichardsBenchmark class >> report: string times: count run: aBlock [
        "Report the time required to execute the given block."

        | time |
        time := 0.
	count timesRepeat: [ time := time + aBlock value ].
        Transcript show: string, ' ', (time // count) printString, ' milliseconds'; cr.
]

{ #category : 'instance creation' }
BeRichardsBenchmark class >> standardBenchmark [
        "This the combined benchmark."
        "BeRichardsBenchmark standardBenchmark"

        self report: 'Richards simulations' times: 100 run: [ self start ]
]

{ #category : 'instance creation' }
BeRichardsBenchmark class >> start [
    "BeRichardsBenchmark start"

    ^self new start
]

{ #category : 'instance creation' }
BeRichardsBenchmark class >> start: trace [
    "BeRichardsBenchmark start: true"

    ^self new start: trace
]

{ #category : 'creation' }
BeRichardsBenchmark >> createDevice: identity priority: priority work: workX state: state [ 
    | dataX |
    dataX := BeRiDeviceTaskDataRecord create.
    self
	createTask: identity
	priority: priority
	work: workX
	state: state
	function: 
	    [:work :word | | data functionWork |
	    data := word.
	    functionWork := work.
	    functionWork isNil
		ifTrue:
		    [(functionWork := data pending) isNil
			ifTrue: [self wait]
			ifFalse: 
			    [data pending: nil.
			    self queuePacket: functionWork]]
		ifFalse: 
		    [data pending: functionWork.
		    tracing
			ifTrue: 
			    [self trace: functionWork datum].
		    self holdSelf]]
	data: dataX
]

{ #category : 'creation' }
BeRichardsBenchmark >> createHandler: identity priority: priority work: workX state: state [ 
    | dataX |
    dataX := BeRiHandlerTaskDataRecord create.
    self
	createTask: identity
	priority: priority
	work: workX
	state: state
	function: 
	    [:work :word | | data workPacket count devicePacket |
	    data := word.
	    work isNil
		ifFalse: [WorkPacketKind == work kind 
		    ifTrue: [data workInAdd: work]
		    ifFalse: [data deviceInAdd: work]].
	    (workPacket := data workIn) isNil
		ifTrue: [self wait]
		ifFalse: 
		    [count := workPacket datum.
		    count > 4
			ifTrue: 
			    [data workIn: workPacket link.
			    self queuePacket: workPacket]
			ifFalse:
			    [(devicePacket := data deviceIn) isNil
				ifTrue: [self wait]
				ifFalse: 
				    [data deviceIn: devicePacket link.
				    devicePacket datum: (workPacket data at: count).
				    workPacket datum: count + 1.
				    self queuePacket: devicePacket]]]]
	data: dataX
]

{ #category : 'creation' }
BeRichardsBenchmark >> createIdler: identity priority: priority work: workX state: state [ 
    | dataX |
    dataX := BeRiIdleTaskDataRecord create.
    self
	createTask: identity
	priority: priority
	work: workX
	state: state
	function: 
	    [:work :word | | data |
	    data := word.
	    data count: data count - 1.
	    0 = data count
		ifTrue: [self holdSelf]
		ifFalse:
		    [0 = (data control bitAnd: 1)
			ifTrue: 
			    [data control: data control // 2.
			    self release: DeviceA]
			ifFalse: 
			    [data control: (data control // 2 bitXor: 53256).
			    self release: DeviceB]]]
	data: dataX
]

{ #category : 'creation' }
BeRichardsBenchmark >> createPacket: link identity: identity kind: kind [ 
    ^BeRiPacket
	create: link
	identity: identity
	kind: kind
]

{ #category : 'creation' }
BeRichardsBenchmark >> createTask: identity priority: priority work: workX state: state function: aBlock data: data [ 
    | t |
    t := BeRiTaskControlBlock
		link: taskList
		create: identity
		priority: priority
		initialWorkQueue: workX
		initialState: state
		function: aBlock
		privateData: data.
    taskList := t.
    taskTable at: identity put: t
]

{ #category : 'creation' }
BeRichardsBenchmark >> createWorker: identity priority: priority work: workX state: state [ 
    | dataX |
    dataX := BeRiWorkerTaskDataRecord create.
    self
	createTask: identity
	priority: priority
	work: workX
	state: state
	function: 
	    [:work :word | | data |
	    data := word.
	    work isNil
		ifTrue: [self wait]
		ifFalse: 
		    [data destination: (HandlerA = data destination
			    ifTrue: [HandlerB]
			    ifFalse: [HandlerA]).
		    work identity: data destination.
		    work datum: 1.
		    1 to: 4 do: 
			[:i | 
			data count: data count + 1.
			data count > 26 ifTrue: [data count: 1].
			work data at: i put: $A asInteger + data count - 1].
		    self queuePacket: work]]
	data: dataX
]

{ #category : 'private' }
BeRichardsBenchmark >> findTask: identity [ 
    | t |
    t := taskTable at: identity.
    t isNil ifTrue: [self error: 'findTask failed'].
    ^t
]

{ #category : 'private' }
BeRichardsBenchmark >> holdSelf [
    holdCount := holdCount + 1.
    currentTask taskHolding: true.
    ^currentTask link
]

{ #category : 'private' }
BeRichardsBenchmark >> initScheduler [
    queuePacketCount := holdCount := 0.
    taskTable := Array new: 6.
    taskList := nil
]

{ #category : 'private' }
BeRichardsBenchmark >> initTrace: trace [
    tracing := trace.
    layout := 0
]

{ #category : 'private' }
BeRichardsBenchmark >> queuePacket: packet [ 
    | t |
    t := self findTask: packet identity.
    t isNil ifTrue: [^nil].
    queuePacketCount := queuePacketCount + 1.
    packet link: nil.
    packet identity: currentTaskIdentity.
    ^t addInput: packet checkPriority: currentTask
]

{ #category : 'private' }
BeRichardsBenchmark >> release: identity [ 
    | t |
    t := self findTask: identity.
    t isNil ifTrue: [^nil].
    t taskHolding: false.
    t priority > currentTask priority
	ifTrue: [^t]
	ifFalse: [^currentTask]
]

{ #category : 'scheduling' }
BeRichardsBenchmark >> schedule [
    currentTask := taskList. 
    [currentTask isNil]
	whileFalse: 
	    [currentTask isTaskHoldingOrWaiting
		ifTrue: [currentTask := currentTask link]
		ifFalse: 
		    [currentTaskIdentity := currentTask identity.
		    tracing ifTrue: [self trace: currentTaskIdentity].
		    currentTask := currentTask runTask]]
]

{ #category : 'initialize' }
BeRichardsBenchmark >> start [
    ^self start: false

]

{ #category : 'initialize' }
BeRichardsBenchmark >> start: trace [
    | workQ mark1 mark2 mark3 mark4 |
    self initTrace: trace; initScheduler.
    mark1 := Time microsecondClockValue.
    tracing ifTrue: [Transcript show: 'Bench mark starting'; cr].
    self
	createIdler: Idler
	priority: 0
	work: nil
	state: BeRiTaskState running.
    workQ := self
		createPacket: nil
		identity: Worker
		kind: WorkPacketKind.
    workQ := self
		createPacket: workQ
		identity: Worker
		kind: WorkPacketKind.
    self
	createWorker: Worker
	priority: 1000
	work: workQ
	state: BeRiTaskState waitingWithPacket.
    workQ := self
		createPacket: nil
		identity: DeviceA
		kind: DevicePacketKind.
    workQ := self
		createPacket: workQ
		identity: DeviceA
		kind: DevicePacketKind.
    workQ := self
		createPacket: workQ
		identity: DeviceA
		kind: DevicePacketKind.
    self
	createHandler: HandlerA
	priority: 2000
	work: workQ
	state: BeRiTaskState waitingWithPacket.
    workQ := self
		createPacket: nil
		identity: DeviceB
		kind: DevicePacketKind.
    workQ := self
		createPacket: workQ
		identity: DeviceB
		kind: DevicePacketKind.
    workQ := self
		createPacket: workQ
		identity: DeviceB
		kind: DevicePacketKind.
    self
	createHandler: HandlerB
	priority: 3000
	work: workQ
	state: BeRiTaskState waitingWithPacket.
    self
	createDevice: DeviceA
	priority: 4000
	work: nil
	state: BeRiTaskState waiting.
    self
	createDevice: DeviceB
	priority: 5000
	work: nil
	state: BeRiTaskState waiting.
    tracing ifTrue: [Transcript show: 'Starting'; cr].
    mark2 := Time microsecondClockValue.
    self schedule.
    mark3 := Time microsecondClockValue.
    tracing
	ifTrue: 
	    [Transcript show: 'Finished'; cr.
	    Transcript show: 'QueuePacket count = ' ;
		show: queuePacketCount printString;
		show: ' HoldCount = ';
		show: holdCount printString;
		cr.
	    Transcript cr; show: 'End of run'; cr].
    queuePacketCount = 23246 & (holdCount = 9297) ifFalse: [self error: 'wrong result'].
    mark4 := Time millisecondClockValue.
    tracing
	ifTrue:
	    [Transcript show: '***Scheduler time = ';
	        show: (mark3 - mark2) printString;
	        show: ' Total time = ';
	        show: (mark4 - mark1) printString;
	        cr].

  ^mark3 - mark2
]

{ #category : 'private' }
BeRichardsBenchmark >> trace: id [ 
    layout := layout - 1.
    0 >= layout
	ifTrue: 
	    [Transcript cr.
	    layout := 50].
    Transcript show: id printString
]

{ #category : 'private' }
BeRichardsBenchmark >> wait [ 
    currentTask taskWaiting: true.
    ^currentTask
]


