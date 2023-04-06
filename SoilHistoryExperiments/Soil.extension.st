Extension { #name : #Soil }

{ #category : #'*SoilHistoryExperiments' }
Soil >> newTransactionForVersion: anInteger [

	^ SOTransaction new
		  soil: self;
		  readVersion: anInteger;
		  yourself
]
