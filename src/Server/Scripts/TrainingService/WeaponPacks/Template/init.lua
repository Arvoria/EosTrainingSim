local WeaponPack = {
	Name = "DefaultWeaponPack",
	Description = "The default weapon pack.",
	Container = false, -- Instance
}
WeaponPack.__index = WeaponPack

function WeaponPack.new(self)
	return setmetatable(self, WeaponPack)
end

function WeaponPack:Load(GamemodeParams)
	local Selected = GamemodeParams.Weapons
end

return WeaponPack