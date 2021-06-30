-- upload-assets(directory, version, buildName)

local args = {...}

local _dir = args[1]
local _version = args[2]
local _buildName = args[3]


local semver_pattern = "^(%S+-%S+).rbxlx"
local studio_pattern = ".lock$"

local file_name = string.format("%s-%s.rbxlx", _version, _buildName)
local _target = string.format("%s/%s", _dir, file_name)
local place_files = remodel.readDir(_dir)

local assets = remodel.readDir("Assets")

local function findStudioFile(files)
	for _, fileName in pairs(files) do
		if not fileName:match(studio_pattern) then
			print("not found the file")
		else
			print("found match:", fileName)
			return fileName:match(semver_pattern)..".rbxlx"
		end
	end
	return nil
end

local function doesVersionBuildExist(target)
	local semver = target:match(semver_pattern)

	for _, fileName in pairs(place_files) do
		if fileName:match(semver_pattern) ~= semver then
			print("not found file")
		else
			return true
		end
	end
	return false
end

local function writeAssets()
	local place = remodel.readPlaceFile(_target)
	local storage = place:GetService("ServerStorage")

	for _, folder in pairs(assets) do
		local root = remodel.readDir("Assets/"..folder)

		if not storage:FindFirstChild(folder) then
			local new_folder = Instance.new("Folder")
			new_folder.Name = folder
			new_folder.Parent = storage
		end

		local place_folder = storage:FindFirstChild(folder)

		for _, asset in pairs(root) do
			local path = "Assets/"..folder.."/"..asset
			local instance = remodel.readModelFile(path)[1]
			print(string.format(
				"Writing %s from %s to @%s",
				instance.Name,
				path,
				_target
			))

			if not place_folder:FindFirstChild(instance.Name) then
				instance:Clone().Parent = place_folder
			end
		end
	end

	print("Finished updating assets, writing to @", _target)
	remodel.writePlaceFile(place, _target)
end

local t = os.clock()

if doesVersionBuildExist(file_name) then
	print("Target version exists")
	if file_name == findStudioFile(place_files) then
		print("Target version is currently open in Studio. Aborting.")
		return
	end
	print("Overwriting target version.")
	writeAssets()
else
	print("Target version does not exist, please build a release version or try a different target version or build name.")
	return
end

print("Time taken to update assets: ", os.clock()-t)