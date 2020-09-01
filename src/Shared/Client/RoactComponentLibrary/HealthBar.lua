local import = require(game.ReplicatedStorage.Shared.packages.Import)

local Roact = import "packages/Roact"
local HealthApp = Roact.Component:extend("HealthApp")

local Flipper = import "packages/Flipper"

function HealthApp:init()
	self.healthMotor = Flipper.SingleMotor.new(self.props.humanoid.Health)

	local healthBind, setHealthBind = Roact.createBinding(self.healthMotor:getValue())
	self.healthBinding = healthBind

	self.healthMotor:onStep(setHealthBind)
	self.healthMotor:start()

	self:setState({
		MaxHealth = 100,
		HealthAmount = self.healthBinding,
	})
end

function HealthApp:render()
	return Roact.createElement(
		"ScreenGui", 
		{ -- ScreenGui Props
			Name = "HealthBarGui",
		},
		{ -- ScreenGui Children
			HealthBarContainer = Roact.createElement("Frame", 
				{ -- HealthBarContainer Props
					Name = "HealthBarContainer",
					Size = UDim2.new(0.25, 0, 0.025, 0),
					AnchorPoint = Vector2.new(0.5, 1),
					Position = UDim2.new(0.5, 0, 0.9, 0),
					BackgroundTransparency = 0.6,
					BackgroundColor3 = Color3.fromRGB(30, 30, 30),
					BorderSizePixel = 0,
				},
				{ -- HealthBarContainer Children
					HealthBar = Roact.createElement("Frame", 
						{ -- HealthBar Props
							Size = UDim2.new(0.975, 0, 0.75, 0),
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.new(0.5, 0, 0.5, 0),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
						},
						{ -- HealthBar Children
							Bar = Roact.createElement("Frame",
								{ -- Bar Props
									Size = self.healthBinding:map(function(value)
										value = math.clamp(value, 0, self.state.MaxHealth)
										value = math.round(value)
										value = value/self.state.MaxHealth
										return UDim2.new(value, 0, 1, 0)
									end),
									BackgroundColor3 = self.healthBinding:map(function(value)
										return Color3.fromRGB(0, 200, 75)
									end),
									AnchorPoint = Vector2.new(0, 0.5),
									Position = UDim2.new(0, 0, 0.5, 0),
									BorderSizePixel = 0,
								},
								{ -- Bar Children
									BarGradient = Roact.createElement("UIGradient",
										{ -- BarGradient Props
											Color = self.healthBinding:map(function(value)
												value = math.round(value)
												value = value/self.state.MaxHealth
												value = 1-math.clamp(value, 0.2, 1)
												print(value)
												return ColorSequence.new(
												{
													ColorSequenceKeypoint.new(0, Color3.new(0.2, 0.2, 0.2)),
													ColorSequenceKeypoint.new(value, Color3.new(value, value, value)),
													ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
												})
											end),
											Transparency = NumberSequence.new(0),
										}
									),

									BarCornerEffect = Roact.createElement("UICorner", 
										{ -- ContainerCornerEffect Props
											CornerRadius = UDim.new(0.25, 0),
										}
									),
								}
							)
						}
					),

					ContainerCornerEffect = Roact.createElement("UICorner", 
						{ -- ContainerCornerEffect Props
							CornerRadius = UDim.new(0.25, 0),
						}
					),

					HealthText = Roact.createElement("TextLabel", 
						{ -- HealthText Props
							Size = UDim2.new(0.4, 0, 1, 0),
							AnchorPoint = Vector2.new(0, 0.5),
							Position = UDim2.new(1, 0, 0.5, 0),
							BorderSizePixel = 0,
							BackgroundTransparency = 1,
							Text = self.healthBinding:map(function(value)
								value = math.clamp(value, 0, self.state.MaxHealth)
								value = math.round(value)
								return tostring(value).."%"
							end),
							TextColor3 = Color3.fromRGB(0, 200, 60),
							TextSize = 24,
							TextStrokeColor3 = Color3.fromRGB(60, 60, 60),
							TextStrokeTransparency = 0,
							TextXAlignment = Enum.TextXAlignment.Left,
							Font = Enum.Font.GothamBold,
						},
						{ -- HealthText Children
						
						}
					)
				}
			)
		}
	)
end

function HealthApp:didMount()
	local hum = self.props.humanoid

	hum:GetPropertyChangedSignal("Health"):Connect(function()
		self.healthMotor:setGoal(Flipper.Spring.new(hum.Health, 
		{
			frequency = 1,
			dampingRatio = 1,
		}))		
	end)
end

function HealthApp:willUnmount()
	
end

return HealthApp