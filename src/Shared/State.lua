local Import = require(script.Parent.packages.Import)

local Rodux = Import("Packages/Rodux")
local RunService = Import("RunService")

local Store
local thunkMiddleware = Rodux.thunkMiddleware

local GAME_STATE = {
	EventInfo = {
		GUID = "",

		Game = {
			GameId = "",
			Map = false,
			Weapons = false,
			MaxScore = 0,
			TimeLimit = 0,
		},

		Games = {
		},

		Teams = {
			Lobby = {
				Score = 0,
				Ref = false
			},

			Green = {
				Score = 0,
				Ref = false
			},

			Red = {
				Score = 0,
				Ref = false
			}
		}
	}
}

local function shallowCopy(t: table)
	local f = {}
	for name in pairs(t) do
		f[name] = t[name]
	end
	return f
end

local REDUCER = Rodux.combineReducers({

	EventInfo = Rodux.combineReducers({

		Game = Rodux.createReducer(GAME_STATE.EventInfo, {
			SetActive = function(state, action)
				print("Dispatching SetActive", state)

				return action.game
			end
		}),

		Games = Rodux.createReducer(GAME_STATE.EventInfo, {
			AddGame = function(state, action)
				print("Dispatching AddGame", state)
				local copy = shallowCopy(state)
				copy[action.id] = true
				return copy
			end,

			RemoveGame = function(state, action)
				print("Dispatching RemoveGame", state)
				local copy = shallowCopy(state)
				copy[action.id] = nil
				return copy
			end
		}),

		Teams = Rodux.createReducer(GAME_STATE.EventInfo, {
			ScoreChanged = function(state, action)
				print("Dispatching ScoreChanged", state)

				return state
			end
		})
	}),
})

Store = Rodux.Store.new(REDUCER, GAME_STATE, {thunkMiddleware})

return Store