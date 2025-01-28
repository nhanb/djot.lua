-- combine modules (specified as cli arguments) into one file
package.path = "./?.lua;" .. package.path

local modules = {}
for i = 1, #arg do
    modules[#modules + 1] =
        arg[i]:gsub("^../", ""):gsub("%.lua$", ""):gsub("%/", ".")
end

local buffer = {}
local function out(s)
    buffer[#buffer + 1] = s
end

out('-- djot.lua amalgamation generated from')
out('-- https://github.com/nhanb/djot.lua/blob/main/clib/combine_readable.lua')

for _, module in ipairs(modules) do
    out(string.format('package.preload["%s"] = function()', module))
    local path = "../" .. module:gsub("%.", "/") .. ".lua"
    local f = assert(io.open(path, "r"))
    local content = f:read("*all")
    out(content)
    out('end\n')
end

local combined = table.concat(buffer, "\n")
io.stdout:write(combined);
