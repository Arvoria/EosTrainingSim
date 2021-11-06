local Import = require(script.Parent.Parent.packages.Import)

local Rodux = Import("Packages/Rodux")
local Llama = Import("Packages/Llama")

local Dictionary, List = Llama.Dictionary, Llama.List

local PlayerList = {}

return Rodux.createReducer(PlayerList, {
	PlayerList = Rodux.combineReducers({
		Add = function(state, action)

		end,

		Remove = function(state, action)

		end,

		UpdateStat = function(state, action)

		end
	})
})