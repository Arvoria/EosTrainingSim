local TrainingService: ModuleScript = script.Parent.Parent
local _lib: Folder = TrainingService.lib

local GenerateGUID: () -> string = require(_lib.GenerateGUID)

local Template = require(script.Parent.Template)
local Options = require(script.Options)
local Promises = require(script.Promises)

local FFA: table = {_Class="FFA"}

function FFA.new()
	local ffa = Template.new(FFA, Options, Promises)
	local self = {
		GameId = GenerateGUID()
	}
	return setmetatable(self, ffa)
end
return FFA