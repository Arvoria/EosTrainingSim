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

local REDUCER = Rodux.combineReducers({

	Events = Rodux.createReducer(GAME_STATE.Events, {
		UpdateEvent = function(state, action)
			local updated = action.event:Update(action.updates)
			state.List[updated.UUID] = updated
			return updated
		end,

		SetupEvent = function(state, action)
			print("Current Store:", Store:getState())
			print("State passed:", state)

			local setup, gamemode = action.setup, action.gamemode
			local event = TrainingService:SetupEvent(setup, gamemode)
			print("Setup the Event", event)

			state.List[event.UUID] = event
			print("Placed event into state:", state)
			return state
		end,

		SetCurrentEvent = function(state, action)
			state.CurrentEvent = action.event
			return state
		end
	})
})

Store = Rodux.Store.new(REDUCER, GAME_STATE, {loggerMiddleware})

return Store