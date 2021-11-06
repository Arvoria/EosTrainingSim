local import = require(game.ReplicatedStorage.Shared.packages.Import)

local ICON_NAME = "PowerOff"

local Roact = import "Packages/Roact"
local Flipper = import "Packages/Flipper"
local MaterialUI = import "Shared/assets/MaterialUI"

local PowerOff = Roact.Component:extend("Icon")

local Folder = MaterialUI[".icons"][ICON_NAME]
local Icon = Folder[".icon"]

local function shade(props)
	local shading = {}
	for name, image in pairs(Folder) do
		if name ~= ".icon" then
			shading[name] = Roact.createElement(
				"ImageLabel",
				{
					Name = name,
					Image = image,
					Size = UDim2.new(1,0,1,0),
					BackgroundTransparency = 1
				}
			)
		end
	end
	return Roact.createFragment(shading)
end

function PowerOff:init()
	self.hoverMotor = Flipper.SingleMotor.new(0)

	local hoverBinding, setHover = Roact.createBinding(self.hoverMotor:getValue())
	self.hoverBinding = hoverBinding
	self.hoverMotor:onStep(setHover)
	self.hoverMotor:start()

	self:setState({
		Hover = false,
		Effect = {
			Color = {
				from = self.props.iconColor,
				to = self.props.hoverColor or Color3.fromHSV(0, 0, 1),
			}
		}
	})

	self.onInputBegan = function(obj, input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			self:setState({Hover = true})
			self.hoverMotor:setGoal(Flipper.Spring.new(1, {
				frequency = 2.5,
				dampingRatio = 1.25,
			}))
		end
	end

	self.onInputEnded = function(obj, input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			self:setState({Hover = false})
			self.hoverMotor:setGoal(Flipper.Spring.new(0, {
				frequency = 2.5,
				dampingRatio = 1.25,
			}))
		end
	end
end

function PowerOff:render()
	return Roact.createElement(
		"ImageLabel",
		{
			Name  = "Icon",
			Image = Icon,
			Size = self.props.size,
			BackgroundTransparency = 1,
			ImageColor3 = self.hoverBinding:map(function(value)
				return self.state.Effect.Color.from:Lerp(
					self.state.Effect.Color.to,
					value
				)
			end),

			ZIndex = self.props.layer,

			[Roact.Event.InputBegan] = self.onInputBegan,
			[Roact.Event.InputEnded] = self.onInputEnded,
		},
		{
			Shading = Roact.createElement(shade)
		}
	)
end

return PowerOff