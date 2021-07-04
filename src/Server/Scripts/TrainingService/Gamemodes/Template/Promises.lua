local Gamemode = script.Parent
local TrainingService = Gamemode.Parent.Parent
local _lib = TrainingService.lib

local Promise = require(_lib.Promise)

local funcs = { -- should probably pass the store into the funcs
	maxScore = function(Store)
		return Promise.new(function(resolve)
			-- Do Something If Max Score is reached
		end)
	end,
	timeLimit = function(Store)
		return Promise.delay():andThen(function()
			-- Do Something If Time Runes out
		end)
	end,

	findWinningTeam = function()

		return Promise.new(function(resolve)
			-- Find Winning Team and return it
		end)
	end
}

local Promises = {

	GameConditions = {
		Win = function(Store)
			return Promise.race({
				funcs.maxScore(Store):andThen(print),
				funcs.timeLimit(Store):andThen(print)
			})
		end,

		Terminate = {
		}
	}
}

return Promises