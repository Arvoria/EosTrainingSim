local Gamemode = require(script.Parent)

local FFA = {
	_ClassName = "FFA",
	Name = "Free-for-All",
	Aliases = { "ffa", "freeforall", "free-for-all" }
}

function FFA:Run()
	print("Running", self.Name)
	self._event.Time.StartedAt = os.date()
	return true
end

function FFA:Stop()
	print("Stopping", self.Name)
	self._event.Time.EndedAt = os.date()
	return true
end

function FFA.new(self, event)
	return Gamemode.new(self, event)
end

return FFA