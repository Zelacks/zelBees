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
				write("installed!\n")
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
local currentVersions = {{name = "", patch = 0, major = 0, minor = 0}}

local currentVersionsSize = 0
if verFile ~= nil then
	local i = 1
	local curLine = verFile.readLine()
	while curLine ~= nil do
		local tokens = {}
		tokens = split(curLine, " ")
		currentVersions[i].name = tokens[1]
		currentVersions[i].patch = tonumber(tokens[2])
		currentVersions[i].major = tonumber(tokens[3])
		currentVersions[i].minor = tonumber(tokens[4])
		i = i + 1
		curLine = verFile.readLine()
	end
	size = i-1
	verFile.close()
end

print("Installing programs")

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
			
			write(tablevals[1] .. ".......... ")
			
			for _, installedProg in ipairs(currentVersions) do
				if tablevals[1] == installedProg.name then
					if compareVersion(tablevals[2], tablevals[3], tablevals[4], installedProg.patch, installedProg.major, installedProg.minor) == true then
						installProgram(tablevals[1], tablevals[5])
					else
						write("up to date.\n")
					end
					success = 1
				end
			end
			
			--Program not installed, install it
			if success ~= 1 then
				installProgram(tablevals[1], tablevals[5])
			end
			table.insert(programs, tablevals[1] .. " " .. tablevals[2] .. " " .. tablevals[3] ..  " " .. tablevals[4])
			write(programs[1])
			curLine = request.readLine()
		end
		
		verFile = fs.open("./zelBeeVersion", "w")
		for _, line in ipairs(programs) do
			verFile.writeLine(line)
		end
		verFile.close()
	else
		print("couldnt download version file")
	end
end