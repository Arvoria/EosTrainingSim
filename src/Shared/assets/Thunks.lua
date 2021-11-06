local T = {}

function T.makePlayerList(debug)
	return function(store)
		local list = {}

		if debug then
			for _, team in pairs(store:getState().EventInfo.Teams) do
				for name, data in pairs(team.PlayerList) do
					list[name] = data
				end
			end
		end

		for _, team in pairs(game:GetService("Teams"):GetTeams()) do
			for _, player in pairs(team:GetPlayers()) do
				local ls = player:FindFirstChild("leaderstats")
				list[player.Name] = {
					UserId = player.UserId,
					Kills = ls and ls.Kills or 0,
					Rank = ls and ls.Rank or "Debug"
				}
			end
		end

		return list
	end
end

return T