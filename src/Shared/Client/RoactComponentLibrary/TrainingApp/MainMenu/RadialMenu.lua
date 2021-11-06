local import = require(game.ReplicatedStorage.Shared.packages.Import)

local Roact = import "Packages/Roact"

local UIRadialConstraint = import "Roact-Components/UIConstraints/UIRadialConstraint"
local NeumorphicButton = import "Roact-Components/Neumorphic/GenericButton"

local RadialMenu = Roact.Component:extend("RadialMenu")

function RadialMenu:init()
	self:setState({
		SortOrder = self.props.sortOrder,
		Anchor = self.props.anchor,
		Radius = self.props.radius,
		CellSize = self.props.cellSize,
		Elements = self.props.elements,
		Layer = self.props.layer,
	})
end

function RadialMenu:render()
	return Roact.createElement(
		"Frame",
		{
			Name = "RadialMenu",
			Position = UDim2.new(0.25, 0, 0.5, 0),
			Size = UDim2.new(0.5, 0, 1, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
		},
		{
			AspectRatio = Roact.createElement("UIAspectRatioConstraint"),
			RadialButtons = Roact.createElement(UIRadialConstraint, {
				sortOrder = Enum.SortOrder.LayoutOrder,
				anchor = Vector2.new(0.5, 0.5),
				radius = 0.3,
				cellSize = Vector2.new(0.25, 0),
				elements = self.state.Elements,
				layer = 2,
			}),
			OffButton = Roact.createElement(NeumorphicButton, {
				pos = UDim2.new(0.5, 0, 0.5, 0),
				size = UDim2.new(0.25, 0, 0.25, 0),
				icon = self.props.offButton.Icon,
				iconColor = self.props.offButton.IconColor,
				hoverColor = self.props.offButton.HoverColor,
				buttonColor = self.props.offButton.ButtonColor,
				buttonHoverColor = self.props.offButton.ButtonHoverColor,
				layer = 2,
				name = "Off",
			})
		}
	)
end

return RadialMenu