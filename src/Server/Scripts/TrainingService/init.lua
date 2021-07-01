local _lib = script.lib
local Promise = require(_lib.Promise)
local Event = require(script.Event)
local Gamemodes = script.Gamemode
local Gamemode = require(Gamemodes)

local TrainingService = {

	CurrentEvent = nil,

	Events = { }
}

local function findGamemode(mode: string)
	return Gamemodes:FindFirstChild(mode) and require(Gamemodes:FindFirstChild(mode))
end

local function make(setup: table, gamemode: string|table)
	local event: table = Event.new(setup or Event)
	local mode: table = typeof(gamemode)=="table"
		and gamemode.new(gamemode, event)
		or findGamemode(gamemode)

	event.Gamemode = mode
	return event
end

function TrainingService:CreateEvent(setup: table, gamemode: string)
	assert(gamemode and Gamemodes:FindFirstChild(gamemode),
		"Gamemode must be a valid gamemode")
	assert(setup.Supervisors.Manager ~= 0,
		"To Build an Event a Manager must be given.")

	local event: table = make(setup, gamemode)

	self:ConnectEvent(event)
	return event
end

function TrainingService:SetupEvent(setup: table, gamemode: table)
	assert(gamemode and gamemode._ClassName
			and Gamemodes:FindFirstChild(gamemode._ClassName),
		"Gamemode must be a valid gamemode [2]")

	assert(setup.Supervisors.Manager ~= 0,
		"To Build an Event a Manager must be given.")

	local event: table = make(setup, gamemode)

	self:ConnectEvent(event)
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