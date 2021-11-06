local TeamService = game:GetService("Teams")
local Teams = TeamService:GetTeams()

local Storage = game:GetService("ServerStorage")
local MapsStorage = Storage:WaitForChild("Maps"):GetChildren()
local WeaponsStorage = Storage:WaitForChild("Weapons"):GetChildren()

local LOBBY_TEAM_SIZE = -1
local GREEN_TEAM_SIZE = 0
local RED_TEAM_SIZE = 8

local function calculateMinimumPlayers()
	local DefaultMode = (LOBBY_TEAM_SIZE == -1 and GREEN_TEAM_SIZE + RED_TEAM_SIZE == 0)
	if DefaultMode then
		DefaultMode = nil
		return 0
	end

	return GREEN_TEAM_SIZE + RED_TEAM_SIZE
end

return {
	Maps = {
		--/ List Maps that can't be chosen, any maps omitted = selectable
		--/ Default/Recommended maps listed as <Instance|false>

		Bricktops = MapsStorage["Bricktops"] or true,
		Meadows = false
	},

	Weapons = {
		--/ List WeaponPacks that can't be chosen, any weapon packs omitted = selectable
		--/ Default/Recommended maps listed as <Instance|false>

		--RSF = WeaponsStorage:FindFirstChild("RSF") or false,
		Sword = false
	},

	Teams = {
		-- List of Teams that can be chosen, any Team omitted won't be selectable
		-- The customisation of these teams relies on GamemodeParams.CustomTeamSizes

		Lobby = Teams["Lobby"],
		Green = Teams["Arvorians"],
		Red = Teams["Militants"]
	},


	TeamSizes = {
		-- List of Teams and their respective minimum sizes
		-- -1 is undefined/unlimited/unbounded

		Lobby = LOBBY_TEAM_SIZE,
		Green = GREEN_TEAM_SIZE,
		Red = RED_TEAM_SIZE,
	},

	CustomTeamSizes = false, -- Allows overriding of TeamSizes

	MaxScore = 50, -- MaxScore required for win condition
	TimeLimit = 5, -- MaxTimeLimit required for end condition
	MinimumPlayers = calculateMinimumPlayers(), -- GREEN+RED>0 or 0
}