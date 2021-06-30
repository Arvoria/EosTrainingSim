local TrainingService = script.Parent
local _lib = TrainingService.lib

local Signal = require(_lib.Signal)

local Event = {
	UID = nil,
	Gamemode = nil,

	Time = {
		CreatedAt = os.date(),
		StartedAt = nil,
		EndedAt = nil
	},

	Started = nil,
	Ended = nil,

	Supervisors = {
		Manager = nil,
		Assistants = { }
	}
}
Event.__index = Event

function Event.new(self) -- Creates a new workable event
	self = self or { }
	setmetatable(self, Event)

	self.Started = Signal.new()
	self.Ended = Signal.new()
	self.Time.CreatedAt = os.date()

	return self
end

return Event