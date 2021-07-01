return function()
	local Import = require(game:GetService("ReplicatedStorage").Shared.packages.Import)
	local Store = Import("Shared/State")
	local ServerScripts = game:GetService("ServerScriptService")
	local TS = ServerScripts:FindFirstChild("TrainingService")
	local Modes = TS.Gamemode

	local _shared = {
		test_mode = require(Modes.FFA),

		custom_setup = {
			UID = "TestEZ State.spec.lua:",

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
			print("Dispatching action to Store")
			Store:dispatch({
				type = "SetupEvent",
				setup = _shared.custom_setup,
				gamemode = _shared.test_mode
			})
			print("Dispatched")
		end)
	end)
end