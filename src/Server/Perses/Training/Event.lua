--[[

	Private fields and methods are prefixed with a "_"

	Training.Event [Event]

		Fields:

			.State
				Running [bool] --> determines if the event is running or stopped
				TimeRemaining [number] --> determines how much time remains; -1 infers infinite/no duration; nil infers Event.run() hasn't been called
				GamemodeEndConditionMet [bool] 	--> determines if the Gamemode is ready to finish; 
												--> determined by Gamemode.EndConditionMet
				PlayerLocked [bool] --> determines if the current Event is locked from new players joining 
				ConfigLocked [bool] --> determines if the current Event is locked from config changes

			.Config 
				_EventUID [string] --> randomly generated UID for the event
				_GamemodeName [string] --> name of the Gamemode to be used for this TrainingEvent
				_WeaponSetName [string] --> name of the WeaponSet to be used for this TrainingEvent
				_MapName [string] --> name of the Map to be used for this TrainingEvent

			.Data
				_Start [Dictionary] --> os.date() UTC Date Dictionary
				_End [Dictionary] --> os.date() UTC Date Dictionary

			Host [int] --> PlayerId of the host of this TrainingEvent
			CoHosts [Array<int>] --> The PlayerIds of the co-hosts of this TrainingEvent
			Gamemode [Gamemode] --> The gamemode object for this TrainingEvent
			Map [Instance] --> The map for this TrainingEvent
			Weapons [Instance] --> The weapons for this TrainingEvent

		Methods
			.onRoundStart(function: callback) --> callback function comes from Gamemode.Start()
			.onRoundEnd(function: callback) --> callback function comes from Gamemode.End()
			.run() --> listen for state changes and fires appropriate events

		Private Methods:
			._startRound() --> called by onRoundStart()
			._endRound() --> called by onRoundEnd()
			._configureRound(string: config, Variant: value)
]]