local import = require(game.ReplicatedStorage.Shared.packages.Import)

local Roact = import "Packages/Roact"

local NeumorphicButton = import "Roact-Components/Neumorphic/GenericButton"

local ListMenu = Roact.Component:extend("ListMenu")

local function displayButtons(props)
	local buttons = props.elements
	local layout = Roact.createElement(
		"UIListLayout",
		{
			Name = "ListLayout",
			Padding = UDim.new(0.1,0),
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		}
	)
	local elements = {}
	elements["ListLayout"] = layout

	for name, button in pairs(buttons) do
		local e = Roact.createElement(
			button.Component,
			{
				size = UDim2.fromScale(0.25, 0.25),
				icon = button.Icon,
				iconColor = button.IconColor,
				hoverColor = button.HoverColor,
				buttonColor = button.ButtonColor,
				buttonHoverColor = button.ButtonHoverColor,
				layer = props.layer + 1,
				name = name,
			}
		)
		elements[name] = e
	end

	return Roact.createFragment(elements)
end

function ListMenu:init()

end

function ListMenu:render()
	return Roact.createElement(
		"Frame",
		{
			Name = "ListMenu",
			Position = UDim2.new(0.75, 0, 0.5, 0),
			Size = UDim2.new(0.5, 0, 1, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			ZIndex = 1,
		},
		{
			AspectRatio = Roact.createElement("UIAspectRatioConstraint"),
			MenuButtons = Roact.createElement(
				"Folder",
				{},
				{Buttons=Roact.createElement(displayButtons, self.props)}
			)
		}
	)
end

return ListMenu