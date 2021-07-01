local TrainingService = script.Parent
local _lib = TrainingService.lib

local Signal = require(_lib.Signal)

local Event = {
	UUID = "",

	Gamemode = "",

	MapName = "",
	MapModel = false,

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

local function generateUUID(): string
	local t: integer = os.clock()
	local seed: table = {"a", "b", "c", "d", "e", "f", "1", "2", "3", "4", "5", "6", "7", "8", "9", "e"}

	local tb: table = {}
	for i = 1, 32 do
		table.insert(tb, seed[math.random(#seed)])
	end

	local uuid: string = table.concat(tb)
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

function Event.new(self: table): table -- Creates a new workable event
	self = self or { }
	setmetatable(self, Event)

	self.UUID = generateUUID()
	self.Started = Signal.new()
	self.Ended = Signal.new()
	self.Time.CreatedAt = os.date()

	return self
end

function Event:Update(old, changed): table
	for key, value in pairs(changed) do
		if old[key] then
			old[key] = value
		end
	end
	return old
end

return Event