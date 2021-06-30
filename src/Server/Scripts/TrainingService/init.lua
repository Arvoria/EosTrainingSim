local _lib = script.lib
local Promise = require(_lib.Promise)
local Event = require(script.Event)
local Gamemodes = script.Gamemode
local Gamemode = require(Gamemodes)

local TrainingService = {

	CurrentEvent = nil,

	Events = { }
}

function TrainingService:CreateEvent(gameMode: string)
	assert(gameMode and Gamemodes:FindFirstChild(gameMode), "Gamemode must be a valid gamemode")

	local event: table = Event.new(Event)
	local mode: table = require(Gamemodes:FindFirstChild(gameMode))

	mode = Gamemode.new(mode, event)
	event.Gamemode = mode

	self:ConnectEvent(event)

	print(event.UUID)
	return event
end

function TrainingService:SetupEvent(setup: table, gameMode: string)
	assert(gameMode and Gamemodes:FindFirstChild(gameMode), "Gamemode must be a valid gamemode")
	assert(setup.Supervisors.Manager ~= 0, "To Build an Event a Manager must be given.")

	local event: table = Event.new(setup)
	local mode: table = require(Gamemodes:FindFirstChild(gameMode))

	mode = Gamemode.new(mode, event)
	event.Gamemode = mode

	self:ConnectEvent(event)

	print(event.UUID)
	return event
end

function TrainingService:StartEvent(event)
	if event then
		event.Started:Fire()
	end
	return event
end


function TrainingService:StopEvent(event)
	if event then
		event.Ended:Fire()
	end
	return event
end

function TrainingService:ConnectEvent(event)
	event.Started:Connect(function()
		event.Gamemode:Run()
	end)
	event.Ended:Connect(function()
		event.Gamemode:Stop()
	end)
end

return TrainingService