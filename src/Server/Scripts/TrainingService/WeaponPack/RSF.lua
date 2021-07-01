local WeaponPack = require(script.Parent)

local RSF = {
	Name = "RSF",
	Description = "This is the RSF weapon pack.",
	Ref = false,
	Weapons = { }
}

function RSF.new(self)
	return WeaponPack.new(self or RSF)
end

return RSF