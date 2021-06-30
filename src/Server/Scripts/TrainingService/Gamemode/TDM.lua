local TDM = {
	Name = "Team Deathmatch",
	Aliases = { "TDM" }
}

function TDM:Run()
	print("Running", self.Name)
	self._event.Time.StartedAt = os.date()
end

function TDM:Stop()
	print("Stopping", self.Name)
	self._event.Time.EndedAt = os.date()
end

return TDM