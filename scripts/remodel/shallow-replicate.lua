-- shallow-replicate (@targetPlaceFile: String)
local args = {...}

local targetPlaceFile = args[1]
print("Reading in place file...")
local targetPlace = remodel.readPlaceFile(targetPlaceFile)
print("Finished reading place file, running script")

local ServerStorage = targetPlace:GetService("ServerStorage")
local ReplicatedStorage = targetPlace:GetService("ReplicatedStorage")

local ReadFrom, WriteTo = ServerStorage, ReplicatedStorage.Shared.assets

local function shallow_replicate(from, to)
	for _, asset in pairs(from:GetChildren()) do
		local inst = Instance.new(asset.ClassName)
		inst.Name = asset.Name
		inst.Parent = to

		print( ("Created model <%s> <@%s>"):format(inst.Name, inst:GetFullName()) )
	end
end

for _, folder in pairs(ReadFrom:GetChildren()) do
	local existing = WriteTo:FindFirstChild(folder.Name)
	if not existing then
		local new = Instance.new("Folder")
		new.Name = folder.Name
		new.Parent = WriteTo
		shallow_replicate(folder, new)
	else
		shallow_replicate(folder, existing)
	end
end

print("Finished shallow replication of assets")
print( ("Writing to place file <@%s>"):format(targetPlaceFile) )
remodel.writePlaceFile(targetPlace, targetPlaceFile)
print("Finishing writing to place file")