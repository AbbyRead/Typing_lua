#!/usr/bin/env lua
local function read_file(filename)
	local lines = {}
	for line in io.lines(filename) do
		table.insert(lines, line)
	end
	return lines
end

local function stdin_is_interactive()
	local is_windows = package.config:sub(1,1) == "\\"
	
	if is_windows then
		-- Only check with PowerShell on Windows
		local f = io.popen('powershell -NoProfile -Command "[Console]::IsInputRedirected" 2>NUL')
		if f then
			local result = f:read("*l")
			f:close()
			return result == "false"
		end
		return true -- fallback: assume interactive
	else
		-- POSIX systems: use test or tty
		local f = io.popen('test -t 0 && echo true || echo false 2>/dev/null')
		if f then
			local result = f:read("*l")
			f:close()
			return result == "true"
		end
		return true -- fallback: assume interactive
	end
end


local function read_stdin()
	if stdin_is_interactive() then
		io.stderr:write("Error: '-' was given, but no piped input was detected.\n")
		os.exit(1)
	end
	
	-- now it's safe to read stdin
	local content = io.read("*a")
	if not content or content == "" then
		io.stderr:write("Error: No content received from stdin.\n")
		os.exit(1)
	end
	
	local lines = {}
	for line in content:gmatch("([^\n]*)\n?") do
		table.insert(lines, line)
	end
	return lines
end

local function read_clipboard()
	local clipboard_cmds = {
		"pbpaste",        -- macOS
		"xclip -selection clipboard -o", -- X11 Linux
		"wl-paste",       -- Wayland Linux
		-- Windows powershell command with proper escaping
		[[powershell -NoProfile -Command "[Console]::OutputEncoding = [System.Text.Encoding]::UTF8; Get-Clipboard"]],
	}
	
	for _, cmd in ipairs(clipboard_cmds) do
		local f = io.popen(cmd)
		if f then
			local content = f:read("*a")
			f:close()
			if content and content ~= "" then
				-- Proper line splitting: split on \n or \r\n, avoid empty trailing line
				local lines = {}
				for line in content:gmatch("([^\r\n]+)") do
					table.insert(lines, line)
				end
				if #lines > 0 then
					return lines
				end
			end
		end
	end
	
	io.stderr:write("Failed to read clipboard\n")
	os.exit(1)
end

local function wait_for_input()
	io.flush()
	
	local ok, line = pcall(io.read)
	if not ok then
		io.stderr:write("\nInterrupted (SIGINT or read error). Exiting.\n")
		os.exit(0)
	end
	
	if line == nil then
		io.stderr:write("\nEOF reached. Exiting.\n")
		os.exit(0)
	end
end

-- Determine input source
local arg_filename = arg[1]
local lines = {}

if arg_filename == nil then
	lines = read_clipboard()
elseif arg_filename == "-" then
	lines = read_stdin()
else
	local file = io.open(arg_filename, "r")
	if not file then
		io.stderr:write("Could not open file: " .. arg_filename .. "\n")
		os.exit(1)
	end
	file:close()
	lines = read_file(arg_filename)
end

-- Delineate start of typing practice
for _ = 1, 40 do io.write("-") end
print("")

-- Typing practice loop
for i, line in ipairs(lines) do
	io.write("\n")
	print(line)
	wait_for_input()
end
