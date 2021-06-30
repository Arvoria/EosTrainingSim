return function()
	local ServerScriptService = game:GetService("ServerScriptService")
	local TrainingService = require(ServerScriptService.TrainingService)
	local Mode = ServerScriptService.TrainingService.Gamemode
	local Gamemode = require(Mode)

	describe("CreateEvent", function()
		it("Should create an event", function()
			local event = TrainingService:CreateEvent("TDM")
			expect(event).to.be.ok()
		end)
	end)

	describe("SetupEvent", function()
		itFOCUS("Should make an event from a list of arguments", function()
			local custom_setup = {
				UID = "TestEZ TrainingService.spec.lua:17:",

				Supervisors = {
					Manager = 123456789,
					Assistants = {
						456789123, 789123456, 123789456, 2468013579
					}
				}
			}
			local event = TrainingService:SetupEvent(custom_setup, "TDM")
			expect(event.UUID).to.equal(custom_setup.UUID)
		end)
	end)

	describe("StartEvent", function()
		it("Should start an event", function()
			local event = TrainingService:CreateEvent("TDM")
			local started = TrainingService:StartEvent(event)

			expect(event.Time.StartedAt).to.equal(started.Time.StartedAt)
		end)
	end)

	describe("StopEvent", function()
		itFOCUS("Should stop an event", function()
			local event = TrainingService:CreateEvent("TDM")
			expect(event).to.be.ok()

			local started = TrainingService:StartEvent(event)
			expect(event.Time.StartedAt).to.equal(started.Time.StartedAt)

			local stopped = TrainingService:StopEvent(started)
			expect(event.Time.EndedAt).to.equal(stopped.Time.EndedAt)

			-- expectations are proof of consistency between the original event and new event.
		end)
	end)
end