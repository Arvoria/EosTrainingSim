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

local function shallowCopy(t)
	local o = { }
	for k, v in pairs(t) do
		o[k] = v
	end
	return o
end

local function deepCopy(obj, seen)
	if type(obj) ~= 'table' then
		return obj
	end
	if seen and seen[obj] then
		return seen[obj]
	end

	local s = seen or {}
	local res = setmetatable({}, getmetatable(obj))

	s[obj] = res

	for k, v in pairs(obj) do 
		res[deepCopy(k, s)] = deepCopy(v, s)
	end

	return res
  end

local GAME_STATE = {
	CurrentEvent = { }, -- @module Event
	CurrentGamemode = { },--@module Gamemode
	CurrentWeaponPack = { }, --@module WeaponPack
	Teams = { }, --@module Teams

	EventList = { },

	EventInSession = false,
}

local REDUCER = Rodux.combineReducers({

	event = Rodux.createReducer(GAME_STATE.CurrentEvent, {
		UpdateEvent = function(state, action)
			local updated = action.event:Update(action.updates)
			state.EventList[updated.UUID] = updated
			return updated
		end,

		CreateEvent = function(state, action)
			local setup, gamemode = action.setup, action.gamemode
			local event = TrainingService:SetupEvent(setup, gamemode)

			state.EventList[event.UUID] = event
			return event
		end,

		SetCurrentEvent = function(state, action)
			state.CurrentEvent = action.event
			return state
		end
	})
})

Store = Store.new(REDUCER, GAME_STATE, loggerMiddleware)

return Store