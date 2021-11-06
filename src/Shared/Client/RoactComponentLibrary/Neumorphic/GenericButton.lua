local import = require(game.ReplicatedStorage.Shared.packages.Import)

local Roact = import "Packages/Roact"
local RoactRodux = import "Packages/RoactRodux"
local Flipper = import "Packages/Flipper"
local Components = import "Roact-Components"
local MaterialUI = import "Shared/assets/MaterialUI"

local Icons = Components.Icons

local GenericButton = Roact.Component:extend("GenericButton")

local Folder = MaterialUI.Neumorphic.Buttons["Hexagon v2"]

local SpringProps = { frequency = 5, damping = 1}
local OnSpring, OffSpring = Flipper.Spring.new(0, SpringProps), Flipper.Spring.new(1, SpringProps)

local function shade(props)
	local search = props.search or Folder
	local elements = props.elements or {}

	for inst, value in pairs(search) do
		if type(value)==type("") then
			elements[inst] = Roact.createElement(
				"ImageLabel",
				{
					Name = inst,
					Image = value,
					Size = UDim2.new(1,0,1,0),
					BackgroundTransparency = 1,
					ImageTransparency = props.shadingBinding:map(function(motors)
						if inst:find("drop") or inst:find("inner") then
							local t = inst:find("drop") and "DropShadows" or "InnerShadows"

							return motors[t]
						end

						return 0
					end),
					ImageColor3 = props.hoverBinding:map(function(value)
						if inst:find("shape") then
							return props.Effect.Color.from:Lerp(
								props.Effect.Color.to,
								value
							)
						end
					end),
				}
			)
		elseif type(value)==type({}) then
			local n = Roact.createElement(
				"Folder",
				{
					Name=inst,
				},
				{
					Shading = shade(
						{
							search = value, elements = {},
							hoverBinding = props.hoverBinding, shadingBinding = props.shadingBinding,
							Effect = props.Effect
						}
					)
				}
			)
			elements[inst] = n
		end
	end

	return Roact.createFragment(elements)
end

function GenericButton:init()
	self.hoverMotor = Flipper.SingleMotor.new(0)
	self.shadingMotor = Flipper.GroupMotor.new({DropShadows=0, InnerShadows=1})

	local hoverBinding, setHover = Roact.createBinding(self.hoverMotor:getValue())
	self.hoverBinding = hoverBinding
	self.hoverMotor:onStep(setHover)
	self.hoverMotor:start()

	local shadingBinding, setShading = Roact.createBinding(self.shadingMotor:getValue())
	self.shadingBinding = shadingBinding
	self.shadingMotor:onStep(setShading)
	self.shadingMotor:start()

	self:setState({
		Icon = self.props.icon,
		IconColor = self.props.iconColor,
		Layer = self.props.layer,
		Name = self.props.name,
		Hover = self.props.hover,
		Effect = {
			Color = {
				from = self.props.buttonColor,
				to = self.props.buttonHoverColor or Color3.fromHSV(0, 0, 1),
			}
		}
	})

	self.onInputBegan = function(obj, input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			self:setState({Hover = true})
			self.hoverMotor:setGoal(Flipper.Spring.new(1, {
				frequency = 3,
				dampingRatio = 1,
			}))
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
			self:setState({Pressed = true})
			self.shadingMotor:setGoal({
				DropShadows = self.state.Pressed and OffSpring or OnSpring,
				InnerShadows = self.state.Pressed and OnSpring or OffSpring,
			})
		end
	end

	self.onInputEnded = function(obj, input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			self:setState({Hover = false})
			self.hoverMotor:setGoal(Flipper.Spring.new(0, {
				frequency = 2,
				dampingRatio = 1,
			}))
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
			self:setState({Pressed = false})
			self.shadingMotor:setGoal({
				DropShadows = self.state.Pressed and OffSpring or OnSpring,
				InnerShadows = self.state.Pressed and OnSpring or OffSpring,
			})
		end
	end

	self.onClick = function(obj)
		
	end
end

function GenericButton:render()
	return Roact.createElement(
		"ImageButton",
		{
			Name = self.state.Name or "GenericButton",
			Position = self.props.pos,
			Size = self.props.size,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			ZIndex = self.state.Layer,

			--[Roact.Event.Activated] = self.onClick,
			[Roact.Event.InputBegan] = self.onInputBegan,
			[Roact.Event.InputEnded] = self.onInputEnded,
		},
		{
			Shading = Roact.createElement(shade,
				{
					shadingBinding = self.shadingBinding,
					hoverBinding = self.hoverBinding,
					Effect = self.state.Effect
				}
			),
			Icon = Roact.createElement(
				require(Icons[self.state.Icon]),
				{
					size = UDim2.new(1, 0, 1, 0),
					iconColor = self.props.iconColor,
					hoverColor = self.props.hoverColor,
					layer = self.state.Layer + 1
				}
			),
			UIAspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint")
		}
	)
end

return GenericButton