running
tearDown
	super tearDown.
	soil ifNotNil: [
		soil close ]