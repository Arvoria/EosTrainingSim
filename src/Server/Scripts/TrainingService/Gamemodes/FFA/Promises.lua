local Gamemode = script.Parent
local TrainingService = Gamemode.Parent.Parent
local _lib = TrainingService.lib

local Promise = require(_lib.Promise)

local function findWinningTeam()
	return Promise.new(function(resolve)
		-- Find Winning Team and return it
		resolve("FFA Team")
	end)
end

local maxScore = function(Store)
	return Promise.new(function(resolve)
		Store.changed:connect(function()
			local teams = Store:getState().Teams
			for team, state in pairs(teams) do
				if state.Score > Store:getState().Gamemode.MaxScore then
					resolve(team)
				end
			end
		end)
	end)
end

local timeLimit = function(Store)
	local limit = Store:getState().Gamemode.Params.TimeLimit
	local delay = (limit == -1) and 99999 or limit

	return Promise.delay(delay):andThen(function()
		return Promise.new(function(resolve)
			-- Find winning team
			local _, team = findWinningTeam():await()

			resolve(team)
		end)
	end)
end

local forceCommand = function(Store)
	return Promise.delay(99999):andThen(function()
		return Promise.new(function(resolve)
			resolve("Terminated")
		end)
	end)
end

local Promises = {

	GameConditions = {
		Win = function(Store)
			return Promise.race({
				maxScore(Store):andThen(function(winningTeam)
					Store:dispatch(function(store)
						store:dispatch({
							type = "MaxScoreReached",
							winners = winningTeam
						})
					end)
				end),

				timeLimit(Store):andThen(function(winningTeam)
					Store:dispatch(function(store)
						store:dispatch({
							type = "TimeLimitReached",
							winners = winningTeam
						})
					end)
					return winningTeam
				end)
			})
		end,

		Terminate = function(Store)
			return forceCommand(Store)
		end,
	}
}

return Promises