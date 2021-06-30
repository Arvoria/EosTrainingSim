return function()
	local ServerScriptService = game:GetService("ServerScriptService")
	local TrainingService = require(ServerScriptService.TrainingService)

	describe("CreateEvent", function()
		it("Should create an event", function()
			local event = TrainingService:CreateEvent("TDM")
			expect(event).to.be.ok()
		end)
	end)

	describe("StartEvent", function()
		it("Should start an event", function()
			local event = TrainingService:CreateEvent("TDM")
			local started = TrainingService:StartEvent(event)

			expect(event.Time.StartedAt).to.equal(started.Time.StartedAt)
		end)
	end)
end