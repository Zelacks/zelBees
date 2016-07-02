if not http then
  print("Install failed: could not access the web")
  return
end

function checkVersions()

end


function installProgram(name, downloadurl)
	local saveFile = fs.open("./" .. name, "w")
	local request = http.get(downloadurl)
		if request then 
			local response = request.getResponseCode()
			if response == 200 then --valid response
				local curLine = request.readLine()
				while curLine ~= nil do
					saveFile.writeLine(curLine)
					curLine = request.readLine()
				end
				saveFile.close()
				write("installed!")
			end
	end
	
end

function compareVersion(patch, major, minor, ipatch, imajor, iminor)
	if patch > ipatch then
		return true
	else
		if major > ipatch then
			return true
		else
			if minor > iminor then
				return true
			end
		end
	end
	return false	
end

function split(pString, pPattern)
   local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pPattern
   local last_end = 1
   local s, e, cap = pString:find(fpat, 1)

   while s do
      if s ~= 1 or cap ~= "" then
		table.insert(Table,cap)
      end
		last_end = e+1
		s, e, cap = pString:find(fpat, last_end)
   end
   if last_end <= #pString then
      cap = pString:sub(last_end)
      table.insert(Table, cap)
   end
   return Table
end

local verFile = fs.open("./zelBeeVersion", "r")
local currentVersions = {}
local currentVersionsSize = 0
if verFile ~= nil then
	local i = 1
	local curLine = verFile.readLine()
	while curLine ~= nil do
		local tokens = {}
		tokens = split(curLine, " ")
		currentVersionsSize[i].name = tokens[1]
		currentVersionsSize[i].patch = tokens[2]
		currentVersionsSize[i].major = tokens[3]
		currentVersionsSize[i].minor = tokens[4]
		i = i + 1
		curLine = request.readLine()
	end
	size = i-1
	verFile.close()
end



programs = {}

local request = http.get("https://raw.githubusercontent.com/Zelacks/zelBees/master/lua/version.lua")
if request then 
	local response = request.getResponseCode()
	if response == 200 then --valid response
		local curLine = request.readLine()
		while curLine ~= nil do	
			local i = 1
			local tablevals = {}
			local success = 0
			tablevals = split(curLine, " ")
			
			print(tablevals[1] .. ".......... ")
			
			for _, installedProg in ipairs(currentVersions) do
				if tablevals[1] == installedProg.name then
					if compareVersion(tablevals[2], tablevals[3], tablevals[4], installedProg.patch, installedProg.major, installedProg.minor) == true then
						installProgram(tablevals[1], tablevals[5])
					end
					success = 1
					write("up to date.")
				end
			end
			
			--Program not installed, install it
			if success ~= 1 then
				installProgram(tablevals[1], tablevals[5])
			end
			table.insert(programs, curLine)
			curLine = request.readLine()
		end
		
		verFile = fs.open("./zelBeeVersion", "w")
		for _, line in ipairs(programs) do
			verFile.writeLine()
		end
		verFile.close()
	else
		print("couldnt download version file")
	end
end