local import = require(game.ReplicatedStorage.Shared.packages.Import)


local TrainingService = import "/ServerScriptService/TrainingService"
local Event = import "/ServerScriptService/TrainingService/Event"

local FFA = import "/ServerScriptService/TrainingService/Gamemodes/FFA"

local TeamService = game:GetService("Teams")
local Teams = TeamService:GetTeams()

local Store = import "/ServerScriptService/State"
local Thunks = import "Shared"


Store:dispatch({
	type = "TeamChanged",
	team = "Lobby",
	changes = {
		Score = 0,
		Ref = Teams["Lobby"],
		PlayerList = {
			["TestPlayer"] = {
				UserId = -1,

				-- Leaderstats
				Kills = 0,
				Rank = "Developer",
				--Other leaderstats
			}
		}
	}
})

local function makeLeaderstats(player)
	local ls = Instance.new("Folder")
	ls.Name = "leaderstats"

	local kills = Instance.new("IntValue")
	kills.Name = "Kills"
	kills.Value = 0

	local rank = Instance.new("StringValue")
	rank.Name = "Rank"
	rank.Value = player:GetRoleInGroup(14638)

	ls.Parent = player
	kills.Parent = ls
	rank.Parent = ls
end

game.Players.PlayerAdded:Connect(function(player)
	makeLeaderstats(player)
	player.Team = (player.Team == Teams["Lobby"]) and player.Team or Teams["Lobby"]

	Store:dispatch({
		type="PlayerAdded",
		team=player.Team.Name or "nil",
		player=player
	})

	wait(2)

	player.leaderstats.Kills.Value = 10

	Store:dispatch({
		type="PlayerChanged",
		team=player.Team.Name,
		player=player,
		stat="Kills",
		value=player.leaderstats.Kills.Value
	})

end)