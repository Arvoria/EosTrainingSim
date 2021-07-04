local TrainingService = script.Parent
local _lib = TrainingService.lib

local HttpService = game:GetService("HttpService")
local Signal = require(_lib.Signal)

local Event = {
	UUID = "",

	Started = false,
	Ended = false,

	EventMetadata = {
		TimeInfo = {
			Started = "",
			Ended = "",
			Created = ""
		},
		Gamemode = { },
		HostIds = {
			Manager = 0, Assistants = { }
		},
	}
}
Event.__index = Event

function Event.new(self: table): table -- Creates a new workable event
	self = self or { }
	setmetatable(self, Event)

	self.UUID = self.UUID~="" and self.UUID or HttpService:GenerateGUID()
	self.Started = Signal.new()
	self.Ended = Signal.new()
	self.EventMetadata = self.EventMetadata or Event.EventMetadata
	self.EventMetadata.TimeInfo.Created = os.date()
	return self
end

return Event