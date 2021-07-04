local TestFiles = script.Parent.UnitTests:GetDescendants()
local Shared = game:GetService("ReplicatedStorage"):FindFirstChild("Shared")
local Packages = Shared:FindFirstChild("packages")
local TestEZ = require(Packages.TestEZ)

TestEZ.TestBootstrap:run(TestFiles)