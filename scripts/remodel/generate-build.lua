--build-version (directory, name, version, ignore...)
--shanesloth

local remodel = remodel
local args = {...}

local include = { "Assets" }
local exclude = {"Assets/img"}

local _targetDir = args[1] -- directory of the build
local _targetName = args[2] -- name of the build
local _targetVersion = args[3] -- build version

local _targetBuild = ("%s-%s"):format(_targetName, _targetVersion)
local _targetFile = ("%s.rbxlx"):format(_targetBuild)
local build_path = ("%s/%s"):format(_targetDir, _targetFile) -- location of where we are building to

local build = remodel.readPlaceFile(build_path)
local dir = remodel.readDir(_targetDir)

local function findSessionLock(target)
	for _, file in pairs(dir) do
		if file:match(".lock$") then
			if target == file:sub(1, file:len()-5) then
				return true
			end
		end
	end
	return false
end

local function check_ignore(dir)
	for _, glob in pairs(exclude) do
		if dir:find(glob) then
			return true
		else
			return false
		end
	end
end

local function mkDir(p, n)
	local f = Instance.new("Folder")
	f.Name = n
	f.Parent = p
	return f
end

local function writeModels(dir, storage)
	local root = remodel.readDir(dir)
	local assetStorage = storage or build:GetService("ServerStorage")

	if storage == nil then
		-- root folder run
		--local f = makeFolder(dir, assetStorage)
		local f = Instance.new("Folder")
		f.Name = dir:match("%a+$")
		f.Parent = assetStorage
		assetStorage = f
	end

	for _, folder in pairs(root) do
		local _dir = ("%s/%s"):format(dir, folder)

		if remodel.isDir(_dir) and not check_ignore(_dir) then
			
			--local f = makeFolder(_dir, assetStorage)
			local f = Instance.new("Folder")
			f.Name = _dir:match("%a+$")
			f.Parent = assetStorage
			writeModels(_dir, f)
		elseif remodel.isFile(_dir) and not check_ignore(_dir) then
			local file = folder

			if file:match(".rbxmx$") then
				print( ("Writing %s to %s"):format(file, storage:GetFullName()) )
				local model = remodel.readModelFile(_dir)[1]
				
				model.Name = file:sub(1, file:len()-6)
				model.Parent = assetStorage
			end
		end
	end
end

local function writeToBuild()
	if findSessionLock(_targetFile) then
		print("Studio session open for target build, aborting!")
		return
	end
	for _, included in pairs(include) do
		writeModels(included)
	end
	
	remodel.writePlaceFile(build, build_path)
end

print( ("Writing models into %s"):format(build_path) )
writeToBuild()
print("Finished generating build")