running
setUp 
	super setUp.
	soil := Soil path: self path.
	soil 
		destroy;
		initializeFilesystem.