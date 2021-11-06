local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.Shared
local TrainingService = script.Parent
local _lib = TrainingService.lib

local Signal = require(_lib.Signal)
local Store = require(Shared.GameState.State)

local Event = {
	GUID = "",

	Started = false,
	Ended = false,

	Game = {},

	Queue = {},
}
Event.__index = Event

function counter(t)
	local c = 0
	for _ in next, t do
		c = c + 1
	end
	return c
end

function Event.new(): table -- Creates a new workable event
	local self = { }
	self = setmetatable(self, Event)
	self.GUID = HttpService:GenerateGUID()

	return self
end

function Event.addGame(event: table, gamemode: table)
	local gameId = gamemode.GameId
	local gamePos = counter(event.Queue) + 1
	gamemode.GamePosition = gamePos
	event.Queue[gameId] = gamemode

	return function(store)
		store:dispatch({
			type = "AddGame",
			id = gameId
		})
	end
end

function Event.removeGame(event: table, gamemode: table)
	local info = gamemode:toStore()
	return function(store)
		if event.Queue[info.GameId] then
			event.Queue[info.GameId] = nil
			store:dispatch({
				type = "RemoveGame",
				id = info.GameId
			})
		end
	end
end

function Event.run(event: table)

end

--[[
	Should cancel the current running gamemode and remove it from the queue
	It should also cancel Event.run()
]]
function Event.stop(event: table)

end

--[[
	Serialises event information ready to put into the Store
]]
function Event:toStore()
	return {}
end

return Event