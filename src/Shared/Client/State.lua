local Import = require(script.Parent.Parent.packages.Import)

local Rodux = Import("Packages/Rodux")
local RunService = Import("RunService")

local Store
local thunkMiddleware = Rodux.thunkMiddleware

local CLIENT_STATE = {
	Privileges = {
		Trainer = false,
		Admin = false,
	},

	TrainerAppState = {

		IsOpen = false,

		--> Page States
		CurrentPage = false,
		RequestedPage = false,
		PreviousPage = false,

		-- Animation States
		Transitioning = false,

		-- Theming
		Theme = false,
	}
}