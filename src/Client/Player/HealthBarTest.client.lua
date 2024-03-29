local import = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared").packages.Import)
local Roact = import "Packages/Roact"
local HealthBarApp = import "Roact-Components/HealthHud"

local Players = import "/Players"
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local handle = Roact.mount(Roact.createElement(HealthBarApp, {humanoid = Humanoid}), PlayerGui, "HealthBar")