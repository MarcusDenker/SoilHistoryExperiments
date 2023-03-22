baselines
baseline: spec
	<baseline>

	spec for: #'common' do: [
		spec package: #SoilHistoryExperiments with: [  ]].
		spec baseline: 'Soil' with: [ spec repository: 'github://ApptiveGrid/Soil:development/src' ].

	spec
		group: 'default' with: #( 'Soil' 'SoilHistoryExperiments' )