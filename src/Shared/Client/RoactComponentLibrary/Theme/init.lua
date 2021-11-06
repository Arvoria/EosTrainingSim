local import = require(game.ReplicatedStorage.Shared.packages.Import)

local Roact = import "Packages/Roact"

local Themes = script.Themes
local RSFLight, RSFDark = require(Themes.RSFLight), require(Themes.RSFDark)

local ThemeContext = Roact.createContext(RSFDark)

local ThemeProvider = Roact.Component:extend("ThemeProvider")

function ThemeProvider:_update(theme)
	if theme.Name == "Light" then
		self:setState({
			theme = RSFLight,
		})
	elseif theme.Name == "Dark" or theme.Name == "Default" then
		self:setState({
			theme = RSFDark
		})
	else
		warn( ("Unknown theme {%s} detected, falling back to default theme!"):format(theme.Name) )
		self:setState({
			theme = RSFDark
		})
	end
end

function ThemeProvider:init()
	self:_update("Default")
end

function ThemeProvider:render()
	return Roact.createElement(ThemeContext.Provider, {
		value = self.state.theme
	}, self.props[Roact.Children])
end

local function withTheme(cb)
	return Roact.createElement(ThemeContext.Consumer, {
		render = cb
	})
end

return {
	ThemeProvider = ThemeProvider,
	Consumer = ThemeContext.Consumer,
	withTheme = withTheme
}