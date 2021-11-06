local Import = require(script.Parent.Parent.packages.Import)

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
				Ref = false,
				PlayerList = {
					--[[
						["Player1"] = {
							UserId = 1234,
							Kills = 0,
							--Other leaderstats
						}
					]]
				}
			},

			Green = {
				Score = 0,
				Ref = false,
				PlayerList = {}
			},

			Red = {
				Score = 0,
				Ref = false,
				PlayerList = {}
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

		GUID = Rodux.createReducer(GAME_STATE.EventInfo, {
			SetId = function(state, action)
				return action.guid
			end
		}),

		Game = Rodux.createReducer(GAME_STATE.EventInfo, {
			SetActive = function(state, action)
				return action.game
			end
		}),

		Games = Rodux.createReducer(GAME_STATE.EventInfo, {
			AddGame = function(state, action)

				local copy = shallowCopy(state)
				copy[action.id] = true
				return copy
			end,

			RemoveGame = function(state, action)

				local copy = shallowCopy(state)
				copy[action.id] = nil
				return copy
			end
		}),

		Teams = Rodux.createReducer(GAME_STATE.EventInfo, {
			TeamChanged = function(state, action)
				local team = action.team
				local changes = action.changes

				local copy = shallowCopy(state)

				copy[team].Score = changes.Score or copy[team].Score
				copy[team].Ref = changes.Ref or copy[team].Ref
				copy[team].PlayerList = changes.PlayerList or copy[team].PlayerList

				return copy
			end,

			PlayerAdded = function(state, action)

				local team = action.team
				local player = action.player

				local copy = shallowCopy(state)
				local data = {
					UserId = player.UserId,
					Kills = player.leaderstats.Kills,
					Rank = player.leaderstats.Rank
				}
				copy[team].PlayerList[player.Name] = data

				print(copy)
			end,

			PlayerChanged = function(state, action)

				local team = action.team
				local player = action.player
				local stat = action.stat
				local value = action.value

				local copy = shallowCopy(state)
				local data = copy[team].PlayerList[player.Name]

				if data then
					copy[team].PlayerList[player.Name][stat] = value
					return copy
				end

				return copy
			end,

			ResetStats = function(state, action)

			end
		})
	}),
})

Store = Rodux.Store.new(REDUCER, GAME_STATE, {thunkMiddleware})

return Store