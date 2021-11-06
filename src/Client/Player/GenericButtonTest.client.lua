local import = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared").packages.Import)
local Roact = import "Packages/Roact"
local GenericButton = import "Roact-Components/Neumorphic/GenericButton"
local UIRadialConstraint = import "Roact-Components/UIConstraints/UIRadialConstraint"
local TrainerMenu = import "Roact-Components/TrainingApp/MainMenu"

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local DemoUI = Instance.new("ScreenGui")
DemoUI.IgnoreGuiInset = true

local handle = Roact.mount(
	Roact.createElement(TrainerMenu, {
		Name = "Container"
	}),
	DemoUI
)

--Background.Parent = DemoUI
--TestFrame.Parent = DemoUI

DemoUI.Parent = PlayerGui