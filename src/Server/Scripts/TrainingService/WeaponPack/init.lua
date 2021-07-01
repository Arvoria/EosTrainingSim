local WeaponPack = {
	Name = "DefaultWeaponPack",
	Description = "The default weapon pack.",
	Ref = false,
	Weapons = { }
}
WeaponPack.__index = WeaponPack

function WeaponPack.new(self)
	return setmetatable(self, WeaponPack)
end

return WeaponPack