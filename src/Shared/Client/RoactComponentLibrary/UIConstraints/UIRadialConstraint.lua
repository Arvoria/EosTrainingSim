local import = require(game.ReplicatedStorage.Shared.packages.Import)

local Roact = import "Packages/Roact"

local RadialConstraint = Roact.Component:extend("UIRadialConstraint")

local function compute(centre, radius, theta)
  return {
    	x = (centre.x + radius * math.cos(theta)),
    	y = (centre.y + radius * math.sin(theta))
	}
end

local function count(t)
  local n = 0
  for _,_ in pairs(t) do
    n+=1
  end
  return n
end

local function displayButtons(props)

  local Computed = {}
  local Buttons = props.elements
  local _max = count(Buttons)

  local Angle = 360 / _max
  local Radius = props.radius
  local Centre = props.anchor
  local Scale, Offset = props.cellSize.x, props.cellSize.y

  local _counter = 0

  local finished = false

  while not finished do
    for n, button in pairs(Buttons) do
      if props.sortOrder == Enum.SortOrder.LayoutOrder then
        if button.LayoutOrder == _counter then
          local pos = compute(Centre, Radius, math.rad(_counter * Angle))
          local e = Roact.createElement(button.Component, {
            pos = UDim2.new(pos.x, 0, pos.y, 0),
            size = UDim2.new(Scale, Offset, Scale, Offset),
            icon = button.Icon,
            iconColor = button.IconColor,
            hoverColor = button.HoverColor,
            buttonColor = button.ButtonColor,
            buttonHoverColor = button.ButtonHoverColor,
            layer = props.layer,
            name = n,
          })
          Computed[n] = e
          _counter += 1
        end
      else
        local pos = compute(Centre, Radius, math.rad(_counter * Angle))
        local e = Roact.createElement(
          button.Component,
          {
            pos = UDim2.new(pos.x, 0, pos.y, 0),
            size = UDim2.new(Scale, Offset, Scale, Offset),
            icon = button.Icon,
            iconColor = button.IconColor,
            hoverColor = button.HoverColor,
            buttonColor = button.ButtonColor,
            buttonHoverColor = button.ButtonHoverColor,
            layer = props.layer,
            name = n,
          }
        )
        Computed[n] = e
        _counter += 1
      end
    end
    if _counter >= _max then
      finished = true
    end
  end

  return Roact.createFragment(Computed)
end

function RadialConstraint:init()
  self:setState({
    SortOrder = self.props.sortOrder,
    AnchorPoint = self.props.anchor,
    Radius = self.props.radius,
    CellSize = self.props.cellSize,
  })
end

function RadialConstraint:render()
  return Roact.createElement("Folder",
    {
      Name = "UIRadialConstraint",
    },
    {
      MenuButtons = Roact.createElement(
        displayButtons,
        {
          elements=self.props.elements,
          cellSize=self.state.CellSize,
          sortOrder=self.state.SortOrder,
          anchor=self.state.AnchorPoint,
          radius=self.state.Radius,
          layer=self.props.layer,
        }
      )
    }
  )
end

return RadialConstraint