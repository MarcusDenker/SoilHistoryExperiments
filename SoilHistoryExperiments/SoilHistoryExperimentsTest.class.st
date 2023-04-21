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
	"we fake the dates for now"
	"should be timestamp"
	(tx root at: #versionMapping) at: dateAndTime - (Duration days: 1) put: 2.
	(tx root at: #versionMapping) at: dateAndTime put: 3.
	tx commit.

	tx := soil newTransaction.
	tx root at: #value put: 2.
	tx markDirty: tx root.
	tx commit.

	tx := soil newTransaction.
	self assert:( tx root at: #value) equals: 2.
	tx := soil newTransactionForDate: dateAndTime - (Duration days: 1).
	self assert: (tx root at: #value) equals: 1.
	
	tx := soil newTransactionForDate: dateAndTime - (Duration days: 2).
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
	"But we can not change it as there are newer commits"
	tx root at: 1 put: 3.
	tx markDirty: tx root.
	self should: [tx commit] raise: SoilObjectHasConcurrentChange
]
