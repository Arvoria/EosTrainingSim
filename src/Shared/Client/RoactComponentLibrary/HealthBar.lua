local import = require(game.ReplicatedStorage.Shared.packages.Import)

local Roact = import "packages/Roact"
local HealthApp = Roact.Component:extend("HealthApp")

local Flipper = import "packages/Flipper"

function HealthApp:init()
	local health, impulse = self.props.Humanoid.Health, self.props.Impulse

	self.healthMotor = Flipper.GroupMotor.new({Health=health, Impulse=impulse})
	local motors = self.healthMotor:getValue()

	local animation, updateAnimation = Roact.createBinding(motors)
	self.animation = animation

	self.healthMotor:onStep(updateAnimation)
	self.healthMotor:start()



	--[[self.healthMotor = Flipper.SingleMotor.new(self.props.Humanoid.Health)

	local healthBind, setHealthBind = Roact.createBinding(self.healthMotor:getValue())
	self.healthBinding = healthBind

	self.healthMotor:onStep(setHealthBind)
	self.healthMotor:start()

	self:setState({
		MaxHealth = 100,
		HealthAmount = self.healthBinding,
	})--]]
end

function HealthApp:render()
	return Roact.createElement(
		"ScreenGui", 
		{ -- ScreenGui Properties
			Name = "HealthBarGui",
			ZIndexBehavior = Enum.ZIndexBehavior.Global,
		},
		{ -- ScreenGui Children
			HealthBarContainer = Roact.createElement("Frame", 
				{ -- HealthBarContainer Properties
					Size = UDim2.new(0.2, 0, 0.025, 0),
					Position = UDim2.new(0.5, 0, 0.8, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(15, 15, 15),
					BackgroundTransparency = 0.3,
					BorderSizePixel = 0,
					ZIndex = 1,
				},
				{ -- HealthBarContainer Children
					ContainerCorner = Roact.createElement("UICorner",
						{ -- ContainerCorner Properties
							CornerRadius = UDim.new(0.2, 0)
						}
					),

					HealthBar = Roact.createElement("Frame", 
						{ -- HealthBar Properties
							Size = self.animation:map(function(values)
								local value = values.Health
								value = math.clamp(value, 0, self.props.HumanoidMaxHealth)
								value = math.round(value)
								value = value / self.props.HumanoidMaxHealth
								return UDim2.new(value, 0, 1, 0)
							end),
							Position = UDim2.new(0, 0, 0.5, 0),
							AnchorPoint = Vector2.new(0, 0.5),
							BackgroundColor3 = Color3.fromRGB(20, 175, 50),
							BorderSizePixel = 0,
							BackgroundTransparency = 0.1,
							ZIndex = 3,
							
						},
						{ -- HealthBar Children
							BarCorner = Roact.createElement("UICorner",
								{ -- BarCorner Properties
									CornerRadius = UDim.new(0.2, 0)
								}
							),
						}
					),

					HealthLabel = Roact.createElement("TextLabel",
						{ -- HealthLabel Properties
							Size = UDim2.new(0.2, 0, 0.85, 0),
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.new(0.975, 0, 0.5, 0),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							TextColor3 = Color3.fromRGB(90, 200, 90),
							Font = Enum.Font.GothamSemibold,
							TextXAlignment = Enum.TextXAlignment.Right,
							TextStrokeColor3 = Color3.fromRGB(15, 15, 15),
							--TextStrokeTransparency = 0.6,
							TextScaled = true,
							ZIndex = 4,
							Text = self.animation:map(function(values)
								local value = values.Health
								value = math.clamp(value, 0, self.props.HumanoidMaxHealth)
								value = math.round(value)
								value = tostring(value)
								return value
							end),
						},
						{ -- HealthLabel Children
						
						}
					)
				}
			)
		}
	)
end

function HealthApp:didMount()
	local hum = self.props.Humanoid
	local maxHealth = self.props.HumanoidMaxHealth
	local impulse = self.props.Impulse

	hum:GetPropertyChangedSignal("Health"):Connect(function()
		local healthGoal = { frequency=1, dampingRatio=1 }
		local impulseGoal = { frequency=1, dampingRatio=1 }
		local goals = {
			Health = Flipper.Spring.new(hum.Health, healthGoal),
			Impulse = Flipper.Spring.new(impulse, impulseGoal),
		}
		impulse = 1
		self.healthMotor:setGoal(goals)
		impulse = 0
		self.healthMotor:setGoal(goals)
	end)
end

function HealthApp:willUnmount()
	
end

return HealthApp