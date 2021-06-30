local TrainingService = script.Parent

local Gamemode = {
	Name = "BaseGamemode",
	Aliases = { }
}
Gamemode.__index = Gamemode

Gamemode._event = nil

function Gamemode.new(self, event)
	assert(self, "Must provide a Gamemode")
	assert(event, "Must provide an Event the Gamemode is associated with")

	setmetatable(self, Gamemode)
	self._event = event

	return self
end

function Gamemode:OrganiseTeams()

end

function Gamemode:Run()

	self._event.Time.StartedAt = os.date()
end

function Gamemode:Stop()

	self._event.Time.EndedAt = os.date()
end

return Gamemode