return function()
	local ServerScriptService = game:GetService("ServerScriptService")
	local TrainingService = require(ServerScriptService.TrainingService)
	local Mode = ServerScriptService.TrainingService.Gamemode

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

	describeSKIP("CreateEvent", function()
		it("Should make an event from a given setup using a string for the gamemode", function()
			local event = TrainingService:CreateEvent(_shared.custom_setup, "FFA")
			print("Event created using string", event)

			expect(event.UUID).to.equal(_shared.custom_setup.UUID)
		end)
	end)

	describeSKIP("SetupEvent", function()
		it("Should make an event from a given setup, using a Gamemode object for the gamemode", function()
			local gamemode = require(Mode.FFA)
			local event = TrainingService:SetupEvent(_shared.custom_setup, gamemode)
			print("Event Setup using Gamemode", event)

			expect(event.UUID).to.equal(_shared.custom_setup.UUID)
		end)
	end)

	describeSKIP("StartEvent", function()
		it("Should start an event", function()
			local event = TrainingService:CreateEvent(_shared.custom_setup, "FFA")
			local started = TrainingService:StartEvent(event)
			expect(event.Time.StartedAt).to.equal(started.Time.StartedAt)
		end)
	end)

	describeSKIP("StopEvent", function()
		it("Should stop an event", function()
			local event = TrainingService:CreateEvent(_shared.custom_setup, "FFA")
			expect(event).to.be.ok()

			local started = TrainingService:StartEvent(event)
			expect(event.Time.StartedAt).to.equal(started.Time.StartedAt)

			local stopped = TrainingService:StopEvent(started)
			expect(event.Time.EndedAt).to.equal(stopped.Time.EndedAt)

			-- expectations are proof of consistency between the original event and new event.
		end)
	end)
end