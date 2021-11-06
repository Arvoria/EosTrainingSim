local import = require(game.ReplicatedStorage.Shared.packages.Import)

local Roact = import "Packages/Roact"
local Flipper = import "Packages/Flipper"

local MenuButtons = import "script/Buttons"
local RadialMenuButtons = MenuButtons.RadialMenu
local OffButton = MenuButtons.Off
local ListMenuButtons = MenuButtons.ListMenu

local RadialMenuComponent = import "script/RadialMenu"
local ListMenuComponent = import "script/ListMenu"

local TrainerMainMenu = Roact.Component:extend("TrainerMainMenu")

function TrainerMainMenu:init()

end

function TrainerMainMenu:render()
	return Roact.createElement(
		"Frame",
		{
			Name = self.props.Name,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.fromHSV(0, 0, 0.9),
			BorderSizePixel = 0,
			BackgroundTransparency = 0.3,
		},
		{
			RadialMenu = Roact.createElement(RadialMenuComponent, {
				sortOrder = Enum.SortOrder.LayoutOrder,
				anchor = Vector2.new(0.5, 0.5),
				radius = 0.3,
				cellSize = Vector2.new(0.2, 0),
				elements = RadialMenuButtons,
				layer = 2,
				offButton = OffButton,
			}),
			ListMenu = Roact.createElement(ListMenuComponent, {
				-- Properties
				elements = ListMenuButtons,
				layer = 2,
			})
		}
	)
end

return TrainerMainMenu