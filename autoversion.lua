#!/usr/bin/env luajit
-- Autoversion
-- https://github.com/fuxoft/autoversion.lua

-- [[*<= Version '20180302b' =>*]]


local function main()
	local fname = arg[1]
	assert(fname, "No file name supplied.")
	local fd = io.open(fname)
	assert (fd, "Cannot open file: "..fname)
	local txt = assert(fd:read("*a"))
	assert(fd:close())
	print("Read file "..fname..", "..(#txt).." bytes.")
	local found = false
	local newversion, oldversion
	txt = txt:gsub("%[%[%*<= Version '(.........)' =>%*%]%]", function(str)
		found = true
		oldversion = str
		local date, letter = str:match '(%d%d%d%d%d%d%d%d)(%l)'
		assert(date and letter, "Invalid version format.")
		local newdate = os.date("%Y%m%d")
		if date > newdate then
			error(string.format("New date (%s) is smaller than the original date (%s)", newdate, date))
		end
		local newletter = "a"
		if date == newdate then
			newletter = string.char(letter:byte() + 1)
			if newletter > "z" then
				error("Original version letter is 'z', cannot increase it.")
			end
		end
		newversion = newdate .. newletter
		print("New version", newversion)
		return "[[*<= Version '"..newversion.."' =>*]]"
	end, 1)
	if not found then
		error("Didn't find the magic version string in the file.")
	end
	--local tmpfn = "/tmp/fuxoft_autoversion"..os.time()..".txt"
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