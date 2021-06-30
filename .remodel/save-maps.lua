local game = remodel.readPlaceFile(".remodel/TrainingMapsGame.rbxlx")
local storage = game.ServerStorage
local maps = storage.Maps

local path = "src/Server/Assets/Maps"
remodel.createDirAll(path)

for index, map in pairs(maps:GetChildren()) do
	remodel.writeModelFile(map, string.format("%s/%s.rbxmx", path, map.Name))
end