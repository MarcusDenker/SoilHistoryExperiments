*SoilHistoryExperiments
newTransactionForVersion: anInteger

	^ SOTransaction new
		  soil: self;
		  readVersion: anInteger;
		  yourself