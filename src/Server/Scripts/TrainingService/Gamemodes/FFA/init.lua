local Template = require(script.Parent.Template)
local Options = require(script.Options)
local Promises = require(script.Promises)

local FFA: table = {_Class="FFA"}

function FFA.new()
	return Template.new(FFA, Options, Promises)
end
return FFA