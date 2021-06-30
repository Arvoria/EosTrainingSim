local TrainingService = script.Parent
local _lib = TrainingService.lib

local Signal = require(_lib.Signal)

local Event = {
	UUID = 0,
	Gamemode = "",

	Time = {
		CreatedAt = os.date(),
		StartedAt = "",
		EndedAt = ""
	},

	Started = false,
	Ended = false,

	Supervisors = {
		Manager = 0,
		Assistants = { }
	}
}
Event.__index = Event

local function generateUUID()
	local t = os.time()
	local seed = {"a", "b", "c", "d", "e", "f", "1", "2", "3", "4", "5", "6", "7", "8", "9", "e"}

	local tb = {}
	for i = 1, 32 do
		table.insert(tb, seed[math.random(#seed)])
	end

	local uuid = table.concat(tb)
	tb = nil
	seed = nil

	return string.format(
		"%s-%s-%s-%s-%s@%d",
		string.sub(uuid, 1, 8),
		string.sub(uuid, 9, 12),
		string.sub(uuid, 13, 17),
		string.sub(uuid, 17, 20),
		string.sub(uuid, 21, 32),
		t
	)
end

function Event.new(self) -- Creates a new workable event
	self = self or { }
	setmetatable(self, Event)

	self.UUID = generateUUID()
	self.Started = Signal.new()
	self.Ended = Signal.new()
	self.Time.CreatedAt = os.date()

	return self
end

return Event