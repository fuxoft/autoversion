#!/usr/bin/env luajit
-- Autoversion
-- https://github.com/fuxoft/autoversion.lua

local VERSION = ([[*<= Version '2.0.5+D20200617T110930' =>*]]):match("'(.+)'")

local function main()
	local fname = arg[1]
    local optstr = "-v3"

    if fname == "-v" then
        print(VERSION)
        os.exit()
    end

    if arg[2] then
        fname = arg[2]
        optstr = arg[1]
    end

	assert(fname, "No file name supplied.")
	local fd = io.open(fname)
	assert (fd, "Cannot open file: "..fname)
	local txt = assert(fd:read("*a"))
	assert(fd:close())
	local found = false
	local newversion, oldversion
	txt = txt:gsub("%[%[%*<= Version '(.-)' =>%*%]%]", function(str)
		found = true
		oldversion = str
		if optstr == "--show-only" then
			print(oldversion)
			os.exit()
		end
		local x,y,z,build = str:match '(%d+)%.(%d+)%.(%d+)%+(.+)'
		x,y,z = tonumber(x), tonumber(y), tonumber(z)
		if not (x and y and z and build) then
			found = false
			return
		end
		local newbuild = os.date("D%Y%m%dT%H%M%S")
		assert(x >= 0 and y >=0 and z >= 0, "Patch # is negative")
        if optstr == "-v1" then
            x = x + 1
            y = 0
            z = 0
        elseif optstr == "-v2" then
            y = y + 1
            z = 0
        else
		    z = z + 1
        end	
        newversion = x.."."..y.."."..z.."+"..newbuild
		return "[[*<= Version '"..newversion.."' =>*]]"
	end, 1)
	if not found then
		error("Didn't find the magic version string in the file. The magic string example is: [[*<= Version '1.2.345+D20201231T235959' =>*]]")
	end
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
