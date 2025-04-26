-- Neovide
if vim.g.neovide then
    -- Put anything you want to happen only in Neovide here
end

-- Package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;"
-- Package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"

require("config.notify")
-- require("config.image")
require("config.noice")
require("config.treesitter")
