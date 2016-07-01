-- 1 1 1
-- patch major minor

if not http then
  print("Install failed: could not access the web")
  return
end

local files =
{
	{
		name = "zelbeeinstall",
		url = "https://raw.githubusercontent.com/Zelacks/zelBees/master/lua/zelbeeinstall.lua"
	}	
}

local test = "sdfsdfeo dsfsf qwqwdqwd fsdofksdfo fwefsdfsdf"
split(test, " ")





function checkVersions
{
	

}


function compareVersion(patch, major, minor)

end

function split(pString, pPattern)
   local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pPattern
   local last_end = 1
   local s, e, cap = pString:find(fpat, 1)
   print(s .. " " .. " " .. e .. " " .. cap)
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

