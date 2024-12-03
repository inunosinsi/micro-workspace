VERSION = "0.0.1"

local micro = import("micro")
local shell = import("micro/shell")
local config = import("micro/config")
local buffer = import("micro/buffer")

function rootDir()
	local os = import("os")
	local dir, err = os.Getwd()
	local info

	-- 上の階層に移動
	local filepath = import("filepath")
	while true do
		if dir:len() <= 1 then
			break
		end

		-- .microディレクトリがあるか？
		info, err = os.Stat(dir.."/.micro/")
		if err == nil then
			break
		end

		dir = filepath.Dir(dir)
	end

	if dir:len() > 1 then
		return dir.."/"
	else
		return os.Getwd().."/"
	end
end

function find(bp, args)
	local dir = rootDir()

	local cmd = "sh -c 'find "..dir.." -name "
	local pattern = ""
	
	for i = 1, #args do
		pattern = args[i] .. "* "
	end

	cmd = cmd .. pattern .. "| fzf'"

	local output, err = shell.RunInteractiveShell(cmd, false, true)
    if err ~= nil then
    	micro.InfoBar():Error(err)
    else
        fzfOutput(output, {bp})
    end
end

function ftree(bp, args)
	local dir = rootDir()

	local cmd = "sh -c 'find "..dir.." -type d -name "
	local pattern = ""
	
	for i = 1, #args do
		pattern = "\""..args[i] .."*\" "
	end

	cmd = cmd .. pattern .. "| fzf --preview \"tree -C {} | head -200\"'"
	--micro.InfoBar():Error(cmd)

	local output, err = shell.RunInteractiveShell(cmd, false, true)
    if err ~= nil then
    	micro.InfoBar():Error(err)
    else
        fzfOutput(output, {bp})
    end
end

function rg(bp, args)
	local dir = rootDir()

	local cmd = "sh -c 'rg -l "
	local pattern = ""
	
	for i = 1, #args do
		pattern = args[i] .. " "
	end

	cmd = cmd .. pattern .. " "..dir.."| fzf'"

	local output, err = shell.RunInteractiveShell(cmd, false, true)
    if err ~= nil then
    	micro.InfoBar():Error(err)
    else
        fzfOutput(output, {bp})
    end
end

function fzfOutput(output, args)
    local bp = args[1]
    local strings = import("strings")
    output = strings.TrimSpace(output)
    print(output)
    if output ~= "" then
        local buf, err = buffer.NewBufferFromFile(output)
        if err == nil then
            bp:OpenBuffer(buf)
        end
    end
end

function init()
	config.MakeCommand("find", function(bp, args)
    	find(bp, args)
    end, config.NoComplete)

    config.MakeCommand("ftree", function(bp, args)
       	ftree(bp, args)
	end, config.NoComplete)

    config.MakeCommand("rg", function(bp, args)
       	rg(bp, args)
	end, config.NoComplete)
end
