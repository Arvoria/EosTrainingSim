local _lib = script.lib
local Promise = require(_lib.Promise)
local Event = require(script.Event)
local Gamemodes = script.Gamemode
local Gamemode = require(Gamemodes)

local TrainingService = {

	CurrentEvent = nil,

	Events = { }
}

function TrainingService:CreateEvent(gameMode)
	local event = Event.new(Event)
	local mode = require(Gamemodes:FindFirstChild(gameMode))
	
	mode = Gamemode.new(mode, event)
	event.Gamemode = mode

	event.Started:Connect(function()
		event.Gamemode:Run()
	end)
	event.Ended:Connect(function()
		event.Gamemode:Stop()
	end)

	return event
end

function TrainingService:StartEvent(event)
	if event then
		event.Started:Fire()
	end

	return event
end

return TrainingService