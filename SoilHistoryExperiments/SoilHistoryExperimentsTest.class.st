Class {
	#name : #SoilHistoryExperimentsTest,
	#superclass : #TestCase,
	#instVars : [
		'soil'
	],
	#category : #SoilHistoryExperiments
}

{ #category : #accessing }
SoilHistoryExperimentsTest >> path [ 
	^ 'soil-historytests'
]

{ #category : #running }
SoilHistoryExperimentsTest >> setUp [ 
	super setUp.
	soil := Soil path: self path.
	soil 
		destroy;
		initializeFilesystem.
]

{ #category : #running }
SoilHistoryExperimentsTest >> tearDown [
	super tearDown.
	soil ifNotNil: [
		soil close ]
]

{ #category : #tests }
SoilHistoryExperimentsTest >> testHistory [
	| tx |

	tx := soil newTransaction.
	tx root: {1}.
	tx commit.

	tx := soil newTransaction.
	tx root at: 1 put: 2.
	tx markDirty: tx root.
	tx commit.

	tx := soil newTransaction.
	self assert: tx root equals: {2}.

	tx := soil newTransactionForVersion: soil databaseVersion.
	self assert: tx root equals: {2}.

	tx := soil newTransactionForVersion: soil databaseVersion - 1.
	self assert: tx root equals: {1}
]

{ #category : #tests }
SoilHistoryExperimentsTest >> testHistoryByDate [
	| tx root dateAndTime|
	self skip.
	"TODO"
	dateAndTime := DateAndTime now.

	tx := soil newTransaction.
	root := SoilPersistentDictionary new.
	tx root: SoilPersistentDictionary new.
	tx root at: #value put: 1.
	tx root at: #versionMapping put: SoilPersistentDictionary new.
	"we fake the dates for now. we simulate that this transaction was done yesterday"
	(tx root at: #versionMapping) at: dateAndTime - (Duration days: 1) put: soil databaseVersion + 1.
	
	tx commit.

	tx := soil newTransaction.
	"This transaction is done now"
	tx root at: #value put: 2.
	(tx root at: #versionMapping) at: dateAndTime put: soil databaseVersion + 1.
	tx markDirty: tx root.
	tx commit.

	"now we read the current version, not giving any date"
	tx := soil newTransaction.
	self assert:( tx root at: #value) equals: 2.
	
	"do the same, but using the date of now"
	tx := soil newTransactionForDate: dateAndTime.
	self assert: (tx root at: #value) equals: 2.
	
	"now we read the value from yesterday"
	
	tx := soil newTransactionForDate: dateAndTime - (Duration days: 1).
	self assert: (tx root at: #value) equals: 1.
]

{ #category : #tests }
SoilHistoryExperimentsTest >> testHistoryCommitPastIsError [
	| tx |

	tx := soil newTransaction.
	tx root: {1}.
	tx commit.

	tx := soil newTransaction.
	tx root at: 1 put: 2.
	tx markDirty: tx root.
	tx commit.

	tx := soil newTransaction.
	self assert: tx root equals: {2}.

	tx := soil newTransactionForVersion: soil databaseVersion.
	self assert: tx root equals: {2}.

	tx := soil newTransactionForVersion: soil databaseVersion - 1.
	self assert: tx root equals: {1}.
	"But we can not change it as there are newer commits, the database does not support forks yet"
	tx root at: 1 put: 3.
	tx markDirty: tx root.
	self should: [tx commit] raise: SoilObjectHasConcurrentChange
]
