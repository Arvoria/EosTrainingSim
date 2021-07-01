local Import = require(script.Parent.packages.Import)

local Rodux = Import("Packages/Rodux")
local RunService = Import("RunService")
local TrainingService = Import("ServerScripts/TrainingService")

local IsStudio = RunService:IsStudio()

local Store

local ALLOW_DEBUGGING = true

local loggerMiddleware

if IsStudio and ALLOW_DEBUGGING then
	loggerMiddleware = Rodux.loggerMiddleware
end

local GAME_STATE = {
	Events = {
		Current = { },
		List = { },
	},

	Gamemode = {
		Current = { },
	},

	WeaponPack = {
		Current = { },
	},
}

local function deepCopy(t, seen)
	if type(t) ~= 'table' then
		return t
	end
	if seen and seen[t] then
		return seen[t]
	end

	local s = seen or {}
	local res = setmetatable({}, getmetatable(t))

	s[t] = res
	for k, v in pairs(t) do
		res[deepCopy(k, s)] = deepCopy(v, s)
	end

	return res
end

local REDUCER = Rodux.combineReducers({

	Events = Rodux.createReducer(GAME_STATE.Events, {
		UpdateEvent = function(state, action)

		end,

		SetupEvent = function(state, action)
			print("Current Store:", Store:getState())
			print("State passed:", state)

			local newState = deepCopy(state)

			local setup, gamemode = action.setup, action.gamemode
			local event = TrainingService:SetupEvent(setup, gamemode)
			print("Setup the Event", event)

			newState.List[event.UUID] = event
			print("Placed event into state:", newState)
			return newState
		end,

		SetCurrentEvent = function(state, action)

		end
	})
})

Store = Rodux.Store.new(REDUCER, GAME_STATE, {loggerMiddleware})

return Store