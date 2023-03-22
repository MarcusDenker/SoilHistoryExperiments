tests
testHistory
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