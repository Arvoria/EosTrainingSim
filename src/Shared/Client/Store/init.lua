local Import = require(script.Parent.Parent.packages.Import)

local Rodux = Import("Packages/Rodux")

local MockState = {
	PlayerList = {
		MockPlayer = {
			MockStats = {
				MockStat = {
					Name = "Kills",
					Owner = "MockPlayer",
					Value = 0
				}
			},
		}
	}
}

