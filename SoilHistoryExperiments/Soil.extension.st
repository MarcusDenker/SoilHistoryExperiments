Extension { #name : #Soil }

{ #category : #'*SoilHistoryExperiments' }
Soil >> newTransactionForDate: aTimeStamp [
	| tx readVersion dates readDate |
	tx := self newTransaction.
	dates := (tx root at: #versionMapping) keys.
	readDate := dates detect: [:t | t >= aTimeStamp ].
	readVersion := (tx root at: #versionMapping) at: readDate.
	tx abort.
	
	^ SoilTransaction new
		  soil: self;
		  readVersion: readVersion;
		  yourself
]

{ #category : #'*SoilHistoryExperiments' }
Soil >> newTransactionForVersion: anInteger [

	^ SoilTransaction new
		  soil: self;
		  readVersion: anInteger;
		  yourself
]
