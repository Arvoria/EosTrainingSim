local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared: Folder = ReplicatedStorage:WaitForChild("Shared")
local Store: table = require(Shared.GameState.State)

local TrainingService: ModuleScript = script.Parent.Parent
local _lib: Folder = TrainingService.lib
local Signal: table = require(_lib.Signal)
local Promise: table = require(_lib.Promise)

local GenerateUUID: () -> string = require(_lib.GenerateGUID)

local function getSelectedOrDefault(choices)
	local selected
	for _, map in pairs(choices) do
		if selected then
			break
		end
		if map then
			selected = map
		end
	end
	return selected
end

local Gamemode = { -- List of choice settings for the gamemode
	_Class = "Template",

	GameId = "",
	GamePosition = 0,

	DefinedOptions = { },

	Parameters = { -- selected choice setting for the gamemode
		Map = false, -- Options.Maps[1]
		Weapons = false, -- Options.Weapon[1]
		Teams = { }, -- Options.Teams
		TeamSizes = { }, -- Options.TeamSizes

		CustomTeamSizes = false, -- Options.CustomTeamSizes

		MaxScore = 0, -- Options.MaxScore
		TimeLimit = 0, -- Options.MaxTimeLimit
	},

	Teams = {
		Lobby = { },
		Green = { },
		Red = { }
	},

	Start = false, --> Signal
	End = false, --> Signal

	Won = { }, --> (Store: Store<State, Actions>) -> Promise
	Terminate = { }, --> (Store: Store<State, Actions>) -> Promise
	Finished = { } --> (Store: Store<State, Actions>) -> Promise
}
Gamemode.__index = Gamemode

function Gamemode.new(self: table, options: table, promises: table): table
	self = self or {}
	self.__index = Gamemode

	setmetatable(self, Gamemode)
	self.init(self, options, promises)
	return self
end

function Gamemode.init(self, options, promises): nil
	--/ Initalise Parameters
	self:InitParams(self:Options(options))

	--/ Initalise Teams
	for team, ref in pairs(options.Teams) do
		self.Teams[team] = {Score = 0, Ref = ref}
	end

	--/ Add Signals
	self.Start = Signal.new()
	self.End = Signal.new()

	-- Add Listeners to Signals
	self.Start:Connect(self.play)
	self.End:Connect(self.stop)

	--/ Add Promise-based Conditions
	self.Won = promises.GameConditions.Win
	self.Terminate = promises.GameConditions.Terminate
end


--[[
--- runs the gamemode
-- this should be ran when a signal is received to start the gamemode
--
]]
function Gamemode.play(self)
	--- loading gamemode sequence
	-- loading map sequence
	--? lock camera to where the map is loading
	-- remove client access to coregui / inventory
	-- set client team
	-- load weapons into client inventory
	-- load clients into the game
	--? unlock their view when everyone is loaded


	--- race end conditions
	-- self.End:Fire(self) -> self.stop(self)
	self.Finished = Promise.any({
		self.Won(Store):andThen(function(winningTeam)
			--doSomething if a team wins
			print(("Finished - %s Won"):format(tostring(winningTeam)))
			return winningTeam
		end),
		self.Terminate(Store):andThen(function(action)
			--doSomethingElse if an action forcibly terminates the game
			print(action)
		end)
	})

	return self.Finished
end


--[[
--- stops the gamemode
-- this should be ran when a command is received to stop the gamemode
-- or when the gamemode meets an end condition
]]
function Gamemode.stop(self)
	print("Stopping:", self)
	-- no need to worry about the winning team, we can
	-- use a promise to grab this value

	--- cleanup player sequence
	-- unload all players
	-- move all players to default team
	-- reload players
end

function Gamemode.isValid(mode): boolean
	for param, value in pairs(mode:Params()) do
		if not mode:CheckPAramValidity(param, value) then
			return false
		end
	end

	return true
end

function Gamemode:InitParams(opt: table): nil
	self:Params(opt)
end

function Gamemode:CheckParamValidity(param, value)
	local opt = self.Parameters[param]
	for key, val in pairs(opt) do
		if value == val then
			return true
		end
	end
	return false
end

function Gamemode:Options(options: table|nil): table
	self.DefinedOptions = options or self.DefinedOptions
	return self.DefinedOptions
end

function Gamemode:Params(newState: table|nil): table
	if newState == nil then
		return self.Parameters
	end

	for key, value in pairs(newState) do
		if key == "Weapons" or key == "Maps" then
			self.Parameters[key] = getSelectedOrDefault(newState[key])
			continue
		end

		if self.Parameters[key] then
			self.Parameters[key] = value
		end
	end

	return self.Parameters
end

function Gamemode:Set(param, value): nil
	if not self:CheckParamValidity(param, value) then
		error(
			("Cannot assign value (%s) to parameter (%s) for this gamemode (%s)"):format(
				tostring(value),
				tostring(param),
				self.GameId
			)
		)
	end

	self.Parameters[param] = value
end

function Gamemode:toStore(): table
	return {
		GameId = self.GameId,
		Map = self.Parameters.Map,
		Weapons = self.Parameters.Weapons,
		MaxScore = self.Parameters.MaxScore,
		TimeLimit = self.Parameters.TimeLimit,
		Teams = self.Teams
	}
end

return Gamemode