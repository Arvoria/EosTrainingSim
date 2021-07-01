local TrainingService = script.Parent
local _lib = TrainingService.lib
local Signal = require(_lib.Signal)
local Promise = require(_lib.Promise)

local Gamemode = {
	Name = "BaseGamemode",
	Aliases = { "Default", "Test", "Mock" },

	TimeLimit = 0,
	ScoreToWin = 0,
	MinimumPlayerLimit = 0,

	AllowCustomTeamLimits = false,

	Teams = { },

	TimeLimitReached = false,
	ScoreReached = false,
	Terminated = false,

}
Gamemode.__index = Gamemode

Gamemode._event = false

function Gamemode.new(self, event)
	assert(self, "Must provide a Gamemode")
	assert(event, "Must provide an Event the Gamemode is associated with")

	setmetatable(self, Gamemode)
	self._event = event

	return self
end

function Gamemode.init(self)
	self.TimeLimitReached = Promise.new(function(resolve)
		if self.TimeLimit ~= -1 then
			return Promise.delay(self.TimeLimit):andThen(function()
				self:TimeLimitReached() -- find winning team
			end)
		else
			return false
		end
	end)

	self.ScoreReached = Promise.new(function(resolve)
		-- go through teams
		-- check if their kills are >= score
		-- resolve with the team that has most kills if both teams have >= score
		-- resolve with the team that reaches the score limit
		-- implement via rodux
	end)
end

function Gamemode:TimeLimitReached()
	--stub method
end

function Gamemode:OrganiseTeams()
	--stub method
end

function Gamemode:Run()
	--stub method
	--do stuff

	self._event.Time.StartedAt = os.date()
end

function Gamemode:Stop()
	--stub method
	--do stuff

	self._event.Time.EndedAt = os.date()
end

return Gamemode