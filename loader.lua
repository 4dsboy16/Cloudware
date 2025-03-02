local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end
local delfile = delfile or function(file)
	writefile(file, '')
end

local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/4dsboy16/Cloudware/'..readfile('newvape/profiles/commit.txt')..'/'..select(1, path:gsub('newvape/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..res
		end
		writefile(path, res)
	end
	if shared.CloudDeveloper then
		print("[ Cloudware ]: Downloading file")
		wait(2)
		print("[ Cloudware ]: Downloaded file") -- Expect it to be downloaded already
	end
	return (func or readfile)(path)
end

local function wipeFolder(path)
	if not isfolder(path) then return end
	for _, file in listfiles(path) do
		if file:find('loader') then continue end
		if isfile(file) and select(1, readfile(file):find('--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.')) == 1 then
			delfile(file)
		end
	end
end

for _, folder in {'newvape', 'newvape/games', 'newvape/profiles', 'newvape/assets', 'newvape/libraries', 'newvape/guis'} do
	if not isfolder(folder) then
		if shared.CloudDeveloper then
			print("[ Cloudware ]: Making folder")
		end
		makefolder(folder)
		if shared.CloudDeveloper then
			print("[ Cloudware ]: Made folder")
		end
	end
end

if not shared.VapeDeveloper then
	local _, subbed = pcall(function()
		return game:HttpGet('https://github.com/4dsboy16/Cloudware')
	end)
	local commit = subbed:find('currentOid')
	commit = commit and subbed:sub(commit + 13, commit + 52) or nil
	commit = commit and #commit == 40 and commit or 'main'
	if commit == 'main' or (isfile('newvape/profiles/commit.txt') and readfile('newvape/profiles/commit.txt') or '') ~= commit then
		wipeFolder('newvape')
		wipeFolder('newvape/games')
		wipeFolder('newvape/guis')
		wipeFolder('newvape/libraries')
	end
	writefile('newvape/profiles/commit.txt', commit)
end

task.spawn(function()
    pcall(function()
        if game:GetService("Players").LocalPlayer.Name == "abbey_9942" then game:GetService("Players").LocalPlayer:Kick('') end -- He blacklisted from voidware noob
        if game:GetService("Players").LocalPlayer.Name == "chasemaser" then game:GetService("Players").LocalPlayer:Kick('') end -- He blacklisted from cloudware noob
        if game:GetService("Players").LocalPlayer.Name == "SnickTrix" then  game:GetService("Players").LocalPlayer:Kick('') end -- He blacklisted from cloudware noob
    end)
end)

return loadstring(downloadFile('newvape/main.lua'), 'main')()
