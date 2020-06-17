#!/usr/bin/env luajit
-- Autoversion
-- https://github.com/fuxoft/autoversion.lua

local VERSION = ([[*<= Version '2.0.4+D20200617T105652' =>*]]):match("'(.+)'")

local function main()
	local fname = arg[1]
	if fname == '--show-only' then
		show_only = true
		fname = arg[2]
	end
	assert(fname, "No file name supplied.")
	local fd = io.open(fname)
	assert (fd, "Cannot open file: "..fname)
	local txt = assert(fd:read("*a"))
	assert(fd:close())
	if not show_only then
		print("Read file "..fname..", "..(#txt).." bytes.")
	end
	local found = false
	local newversion, oldversion
	txt = txt:gsub("%[%[%*<= Version '(.-)' =>%*%]%]", function(str)
		found = true
		oldversion = str
		if show_only then
			print(oldversion)
			os.exit()
		end
		print ("Autoversion v"..VERSION)
		local x,y,z,build = str:match '(%d+)%.(%d+)%.(%d+)%+(.+)'
		x,y,z = tonumber(x), tonumber(y), tonumber(z)
		assert(x and y and z and build, "Invalid version format.")
		local newbuild = os.date("D%Y%m%dT%H%M%S")
		assert(z >= 0, "Patch # is negative")
		z = z + 1
		newversion = x.."."..y.."."..z.."+"..newbuild
		return "[[*<= Version '"..newversion.."' =>*]]"
	end, 1)
	if not found then
		error("Didn't find the magic version string in the file. The magic string example is: [[*<= Version '1.2.345+D20201231T235959' =>*]]")
	end
	--local tmpfn = "/tmp/fuxoft_autoversion"..os.time()..".txt"
	--os.exit()
	local fd = assert(io.open(fname, "w"))
	print("The updated file follows:")
	print("-------------------------------------------")
	print(txt)
	assert(fd:write(txt))
	assert(fd:close())
	print("------------------------------------------- OK")
	print("Succesfully updated file ".. fname .. " from version " .. oldversion .. " to "..newversion)
end

main()