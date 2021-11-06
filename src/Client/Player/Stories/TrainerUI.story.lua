local import = require(game.ReplicatedStorage.Shared.packages.Import)

local Roact = import "Packages/Roact"
local TrainerUI = import "Roact-Components/TrainingApp/MainMenu"

return function(target)
	local DemoUI = Instance.new("ScreenGui")
	DemoUI.IgnoreGuiInset = true

	local handle = Roact.mount(
		Roact.createElement(TrainerUI, {
			Name = "Container"
		}),
		DemoUI
	)
	DemoUI.Parent = target

	return function()
		Roact.unmount(handle)
		DemoUI:Destroy()
	end
end