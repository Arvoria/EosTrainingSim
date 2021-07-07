local TrainingService = game.ServerScriptService.TrainingService
local Gamemodes = TrainingService.Gamemodes
local FFA = require(Gamemodes.FFA)

local Store = require(game:GetService("ReplicatedStorage").Shared.State)
local Event = require(TrainingService.Event)

local E = Event.new()
local games = {
	[1] = FFA.new()
}

Store:dispatch(Event.addGame(E, games[1]))
print("Games:", Store:getState().EventInfo.Games)
Store:dispatch(Event.removeGame(E, games[1]))
print("Games:", Store:getState().EventInfo.Games)