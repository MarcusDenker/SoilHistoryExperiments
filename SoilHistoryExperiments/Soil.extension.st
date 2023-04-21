Extension { #name : #Soil }

{ #category : #'*SoilHistoryExperiments' }
Soil >> newTransactionForVersion: anInteger [

	^ SoilTransaction new
		  soil: self;
		  readVersion: anInteger;
		  yourself
]
