local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Store = require(ReplicatedStorage.Shared.State)

local TrainingService = script.Parent.Parent
local _lib = TrainingService.lib
local Signal = require(_lib.Signal)
local Promise = require(_lib.Promise)

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

local Options = require(script.Options)
local Promises = require(script.Promises)

local Gamemode = { -- List of choice settings for the gamemode
	Parameters = { -- selected choice setting for the gamemode
		Map = false, -- Options.Maps[1]
		Weapons = false, -- Options.Weapon[1]
		Teams = { }, -- Options.Teams
		TeamSizes = { }, -- Options.TeamSizes

		CustomTeamSizes = false, -- Options.CustomTeamSizes

		MaxScore = 0, -- Options.MaxScore
		MaxTimeLimit = 0, -- Options.MaxTimeLimit
	},

	Start = false, --> Signal
	End = false, --> Signal

	WinningTeam = false, --> Promise

	Win = { }, --> (Store: Store<State, Actions>) -> Promise
	Terminate = { }, --> (Store: Store<State, Actions>) -> Promise
	Finished = { } --> (Store: Store<State, Actions>) -> Promise
}
Gamemode.__index = Gamemode

function Gamemode.new(self)
	self = self or Gamemode
	setmetatable(self, Gamemode)

	self.init(self)
end

function Gamemode.init(self)
	--/ Add Promise-based Conditions
	self.Won = Promises.GameConditions.Win
	self.Terminate = Promises.GameConditions.Terminate

	--/ Add Signals
	self.Start = Signal.new()
	self.End = Signal.new()

	--/ Initalise Parameters
	self:InitParams()

	-- Add Listeners to Signals
	self.Start:Connect(self.play, self)
	self.End:Connect(self.stop, self)
end


--[[
--- runs the gamemode
-- this should be ran when a command is received to start the gamemode
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
end


--[[
--- stops the gamemode
-- this should be ran when a command is received to stop the gamemode
-- or when the gamemode meets an end condition
]]
function Gamemode.stop(self)
	-- no need to worry about the winning team, we can
	-- use a promise to grab this value

	--- cleanup player sequence
	-- unload all players
	-- move all players to default team
	-- reload players
end

function Gamemode:InitParams()

	self.Parameters.Map = getSelectedOrDefault(Options.Maps)
	self.Parameters.Weapons = getSelectedOrDefault(Options.Weapons)
	self.Parameters.TeamSizes = Options.TeamSizes

	self.Parameters.CustomTeamSizes = Options.CustomTeamSizes

	self.Parameters.MaxScore = Options.MaxScore
	self.Parameters.MaxTimeLimit = Options.MaxTimeLimit
end

function Gamemode:InitPromises()
	self.Finished = Promise.race({
		self.Won():andThen(function()
			--doSomething if a team wins
		end),
		self.Terminate():andThen(function()
			--doSomethingElse if an action forcibly terminates the game
		end)
	})
end

function Gamemode:CheckValidity()

end

function Gamemode:Options()

end

function Gamemode:Params()

end

return Gamemode