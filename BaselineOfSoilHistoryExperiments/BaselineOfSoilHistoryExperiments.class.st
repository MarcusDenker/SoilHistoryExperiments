Class {
	#name : #BaselineOfSoilHistoryExperiments,
	#superclass : #BaselineOf,
	#category : 'BaselineOfSoilHistoryExperiments'
}

{ #category : #baselines }
BaselineOfSoilHistoryExperiments >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec package: #SoilHistoryExperiments with: [ ]].
		spec baseline: 'Soil' with: [ spec repository: 'github://ApptiveGrid/Soil:development/src' ].

	spec
		group: 'default' with: #( 'Soil' 'SoilHistoryExperiments' )

]
