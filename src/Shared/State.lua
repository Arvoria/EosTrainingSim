local Import = require(script.Parent.packages.Import)

local Rodux = Import("Packages/Rodux")
local Promise = Import("Packages/Promise")
local RunService = Import("RunService")
local TrainingService = Import("ServerScripts/TrainingService")
local Event = TrainingService.Event

local IsStudio = RunService:IsStudio()

local Store

local ALLOW_DEBUGGING = false

local loggerMiddleware
local thunkMiddleware = Rodux.thunkMiddleware

if IsStudio and ALLOW_DEBUGGING then
	loggerMiddleware = Rodux.loggerMiddleware
end

local GAME_STATE = {
	Event = { },
	Gamemode = { Properties = {} },

	EventList = { }
}

local REDUCER = Rodux.combineReducers({

	TrainingState = Rodux.createReducer(GAME_STATE.TrainingState, {

		BaseReducer = function(state, action)
			return "Action dispatched"
		end
	})
})

Store = Rodux.Store.new(REDUCER, GAME_STATE, {loggerMiddleware})

return Store