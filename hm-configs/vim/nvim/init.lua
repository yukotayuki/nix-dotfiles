require('joo.base')
require('joo.highlights')
require('joo.maps')
require('joo.plugins')

local has = function(x)
    return vim.fn.has(x) == 1
end

local is_linux = has "linux"
local is_mac = has "macunix"
local is_win = has "win32"

if is_mac then
    require('joo.macos')
end
if is_win then
    require('joo.windonws')
end

if is_linux then
    require('joo.linux')
end
