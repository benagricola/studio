Class {
	#name : #RJITTraceAbortEvent,
	#superclass : #RJITTraceEvent,
	#instVars : [
		'error'
	],
	#category : #'Studio-RaptorJIT'
}

{ #category : #decoding }
RJITTraceAbortEvent >> decode [

]

{ #category : #decoding }
RJITTraceAbortEvent >> from: dict flashback: aFlashback [
	super from: dict flashback: aFlashback.
	error := dict at: 'TraceError'.

]

{ #category : #accessing }
RJITTraceAbortEvent >> info [
	| info |
	info := super info.
	info add: 'Error reason' -> (self traceError , ': ' , self traceErrorReason).
	info add: 'Final?' -> (self jitState isFinal
		ifTrue: [ 'Yes: The starting point of this trace is now blacklisted' ]
		ifFalse: [ 'No: More attempts to trace from this point as allowed' ]).
	^ info.

]

{ #category : #printing }
RJITTraceAbortEvent >> printOn: aStream [
	| final |
	final := self jitState isFinal ifTrue: '(final) ' ifFalse: ''.
	aStream nextPutAll: 'trace abort ', final, ' from ', self startSourceLine, ' to ', self endSourceLine, ' (', self numberOfBytecodes asString, ' bytecodes)'
]

{ #category : #'as yet unclassified' }
RJITTraceAbortEvent >> traceError [
	^ flashback auditLog dwarf valueToName: error inEnumerationWith: 'LJ_TRERR_NYIBC'.
]

{ #category : #'as yet unclassified' }
RJITTraceAbortEvent >> traceErrorReason [
	^ self traceErrorReasons at: self traceError.

]

{ #category : #'as yet unclassified' }
RJITTraceAbortEvent >> traceErrorReasons [
	^ {
	    #LJ_TRERR_RECERR  -> 'error thrown or hook called during recording'.
       #LJ_TRERR_TRACEUV -> 'trace too short'.
       #LJ_TRERR_TRACEOV -> 'trace too long'.
       #LJ_TRERR_STACKOV -> 'trace too deep'.
       #LJ_TRERR_SNAPOV  -> 'too many snapshots'.
       #LJ_TRERR_BLACKL  -> 'blacklisted'.
       #LJ_TRERR_RETRY   -> 'retry recording'.
       #LJ_TRERR_NYIBC   -> 'NYI: bytecode'.
       #LJ_TRERR_LLEAVE  -> 'leaving loop in root trace'.
       #LJ_TRERR_LINNER  -> 'inner loop in root trace'.
       #LJ_TRERR_LUNROLL -> 'loop unroll limit reached'.
       #LJ_TRERR_BADTYPE -> 'bad argument type'.
       #LJ_TRERR_CJITOFF -> 'JIT compilation disabled for function'.
       #LJ_TRERR_CUNROLL -> 'call unroll limit reached'.
       #LJ_TRERR_DOWNREC -> 'down-recursion, restarting'.
       #LJ_TRERR_NYIFFU  -> 'NYI: unsupported variant of FastFunc'.
       #LJ_TRERR_NYIRETL -> 'NYI: return to lower frame'.
       #LJ_TRERR_STORENN -> 'store with nil or NaN key'.
       #LJ_TRERR_NOMM    -> 'missing metamethod'.
       #LJ_TRERR_IDXLOOP -> 'looping index lookup'.
       #LJ_TRERR_NYITMIX -> 'NYI: mixed sparse/dense table'.
       #LJ_TRERR_NOCACHE -> 'symbol not in cache'.
       #LJ_TRERR_NYICONV -> 'NYI: unsupported C type conversion'.
       #LJ_TRERR_NYICALL -> 'NYI: unsupported C function type'.
       #LJ_TRERR_GFAIL   -> 'guard would always fail'.
       #LJ_TRERR_PHIOV   -> 'too many PHIs'.
       #LJ_TRERR_TYPEINS -> 'persistent type instability'.
       #LJ_TRERR_MCODEAL -> 'failed to allocate mcode memory'.
       #LJ_TRERR_MCODEOV -> 'machine code too long'.
       #LJ_TRERR_MCODELM -> 'hit mcode limit (retrying)'.
       #LJ_TRERR_SPILLOV -> 'too many spill slots'.
       #LJ_TRERR_BADRA   -> 'inconsistent register allocation'.
       #LJ_TRERR_NYIIR   -> 'NYI: cannot assemble IR instruction'.
       #LJ_TRERR_NYIPHI  -> 'NYI: PHI shuffling too complex'.
       #LJ_TRERR_NYICOAL -> 'NYI: register coalescing too complex'.
	} asDictionary.
]
