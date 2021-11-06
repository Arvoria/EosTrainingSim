local import = require(game.ReplicatedStorage.Shared.packages.Import)
local NeumorphicButton = import "Roact-Components/Neumorphic/GenericButton"

return {

	["Off"] = {
		Component = NeumorphicButton,
		Icon = "PowerOff2",
		IconColor = Color3.fromHSV(0.94, 0.9, 0.8),
		HoverColor = Color3.fromHSV(230/360, 0.15, 0.15),
		ButtonColor = Color3.fromHSV(0, 0, 1),
		ButtonHoverColor = Color3.fromHSV(0, 0, 0.95),
		LayoutOrder = 0,
	},

	RadialMenu = {
		["Maps"] = {
			Component = NeumorphicButton,
			Icon = "PowerOff2",
			IconColor = Color3.fromHSV(0,0,1),
			HoverColor = Color3.fromHSV(0.42, 0.87, 0.98),
			ButtonColor = Color3.fromHSV(0, 0, 1),
			ButtonHoverColor = Color3.fromHSV(0, 0, 0.95),
			LayoutOrder = 0,
		},
		["Weapons"] = {
			Component = NeumorphicButton,
			Icon = "PowerOff2",
			IconColor = Color3.fromHSV(0,0,1),
			HoverColor = Color3.fromHSV(0.42, 0.87, 0.98),
			ButtonColor = Color3.fromHSV(0, 0, 1),
			ButtonHoverColor = Color3.fromHSV(0, 0, 0.95),
			LayoutOrder = 1,
		},
		["Teams"] = {
			Component = NeumorphicButton,
			Icon = "PowerOff2",
			IconColor = Color3.fromHSV(0,0,1),
			HoverColor = Color3.fromHSV(0.42, 0.87, 0.98),
			ButtonColor = Color3.fromHSV(0, 0, 1),
			ButtonHoverColor = Color3.fromHSV(0, 0, 0.95),
			LayoutOrder = 2,
		},
		["Gamemodes"] = {
			Component = NeumorphicButton,
			Icon = "PowerOff2",
			IconColor = Color3.fromHSV(0,0,1),
			HoverColor = Color3.fromHSV(0.42, 0.87, 0.98),
			ButtonColor = Color3.fromHSV(0, 0, 1),
			ButtonHoverColor = Color3.fromHSV(0, 0, 0.95),
			LayoutOrder = 3,
		},
		["Settings"] = {
			Component = NeumorphicButton,
			Icon = "PowerOff2",
			IconColor = Color3.fromHSV(0,0,1),
			HoverColor = Color3.fromHSV(0.42, 0.87, 0.98),
			ButtonColor = Color3.fromHSV(0, 0, 1),
			ButtonHoverColor = Color3.fromHSV(0, 0, 0.95),
			LayoutOrder = 4,
		},
		["Presets"] = {
			Component = NeumorphicButton,
			Icon = "PowerOff2",
			IconColor = Color3.fromHSV(0,0,1),
			HoverColor = Color3.fromHSV(0.42, 0.87, 0.98),
			ButtonColor = Color3.fromHSV(0, 0, 1),
			ButtonHoverColor = Color3.fromHSV(0, 0, 0.95),
			LayoutOrder = 5,
		},
	},

	ListMenu = {
		["SaveEvent"] = {
			Component = NeumorphicButton,
			Icon = "PowerOff2",
			IconColor = Color3.fromHSV(0,0,1),
			HoverColor = Color3.fromHSV(0.42, 0.87, 0.98),
			ButtonColor = Color3.fromHSV(0, 0, 1),
			ButtonHoverColor = Color3.fromHSV(0, 0, 0.95),
			LayoutOrder = 0,
		},
		["RunEvent"] = {
			Component = NeumorphicButton,
			Icon = "PowerOff2",
			IconColor = Color3.fromHSV(0,0,1),
			HoverColor = Color3.fromHSV(0.42, 0.87, 0.98),
			ButtonColor = Color3.fromHSV(0, 0, 1),
			ButtonHoverColor = Color3.fromHSV(0, 0, 0.95),
			LayoutOrder = 1,
		},
		["PreviewEvent"] = {
			Component = NeumorphicButton,
			Icon = "PowerOff2",
			IconColor = Color3.fromHSV(0,0,1),
			HoverColor = Color3.fromHSV(0.42, 0.87, 0.98),
			ButtonColor = Color3.fromHSV(0, 0, 1),
			ButtonHoverColor = Color3.fromHSV(0, 0, 0.95),
			LayoutOrder = 2,
		},
	}
}