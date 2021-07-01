return function()
	local Import = require(game:GetService("ReplicatedStorage").Shared.Import)
	local Store = Import("Shared/State")
	local ServerScripts = game:GetService("ServerScriptService")
	local TS = ServerScripts:FindFirstChild("TrainingService")
	local Modes = TS.Gamemode

	local _shared = {
		custom_setup = {
			UID = "TestEZ TrainingService.spec.lua:17:",

			Supervisors = {
				Manager = 123456789,
				Assistants = {
					456789123, 789123456, 123789456, 2468013579
				}
			}
		}
	}

	describeFOCUS("CreateEvent", function()
		it("Should create an event", function()
			Store:dispatch({
				type = "CreateEvent",
				setup = _shared.custom_setup,
				gamemode = require(Modes.FFA)
			})
			print(Store:getState())
		end)
	end)
end