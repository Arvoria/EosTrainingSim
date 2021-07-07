local Gamemode = script.Parent
local TrainingService = Gamemode.Parent.Parent
local _lib = TrainingService.lib

local Promise = require(_lib.Promise)

local findWinningTeam = function()
	return Promise.new(function(resolve)
		-- Find Winning Team and return it
		resolve("Template Team")
	end)
end

local funcs = { -- should probably pass the store into the funcs
	maxScore = function(Store)
		print("MaxScore Promise")
		return Promise.new(function(resolve)
			-- Find winning team
			local team = findWinningTeam():andThen(function(t)
				return t
			end)
			Promise.delay(math.huge):andThenCall(resolve, team)
		end)
	end,
	timeLimit = function(Store)
		local limit = Store:getState().Gamemode.Params.TimeLimit
		local delay = (limit == -1) and math.huge or limit
		print("TimeLimit Promise Delay:", delay)
		-- Wait out the TimeLimit
		return Promise.new(function(resolve)
			Promise.delay(delay)
			-- Find winning team
			local team = findWinningTeam():andThen(function(t)
				return t
			end)

			resolve(team)
		end)
	end,
}

local Promises = {

	GameConditions = {
		Win = function(Store)
			return Promise.race({
				funcs.maxScore(Store):andThen(function(winningTeam)
					Store:dispatch(function(store)
						print(winningTeam)
						Store:dispatch({
							type = "MaxScoreReached",
							winners = winningTeam
						})
					end)
				end),

				funcs.timeLimit(Store):andThen(function(winningTeam)
					Store:dispatch(function(store)
						print(winningTeam)
						Store:dispatch({
							type = "TimeLimitReached",
							winners = winningTeam
						})
					end)
				end)
			})
		end,

		Terminate = function(Game)
			return Promise.delay(math.huge)
			--[[
				Promise.fromEvent(Game.End, function(Store)
					Store:dispatch({

					})
				)
			]]
		end,
	}
}

return Promises