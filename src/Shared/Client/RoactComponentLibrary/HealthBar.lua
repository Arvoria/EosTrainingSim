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
							BackgroundColor3 = self.animation:map(function(values)
								local value = values.Impulse
								
								local h, s, v = 130-(130*value), 90, 70
								local color = Color3.fromHSV(h/360, s/100, v/100)
								return color
							end),
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
							TextColor3 = self.animation:map(function(values)
								local value = values.Impulse
								
								local h, s, v = 120-(120*value), 40, 85
								local color = Color3.fromHSV(h/360, s/100, v/100)								
								return color
							end),
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
	local oldHealth = hum.Health
	
	hum.HealthChanged:Connect(function(newHealth)
		local didIncrease = newHealth>oldHealth

		self.healthMotor:setGoal({
			Impulse = Flipper.Instant.new(didIncrease and 0 or 1),
			Health = Flipper.Spring.new(newHealth, {frequency=1, dampingRatio=1}),
		})
		self.healthMotor:step(0)
		self.healthMotor:setGoal({Impulse=Flipper.Spring.new(0, {frequency=1, dampingRatio=1})})
		
		oldHealth = newHealth
	end)
end

function HealthApp:willUnmount()
	self.healthMotor:destroy()
end

return HealthApp