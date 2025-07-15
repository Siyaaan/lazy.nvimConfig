-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<F5>", function()
  local file = vim.fn.expand("%")
  local ft = vim.bo.filetype
  local cmd

  if ft == "sh" or ft == "bash" then
    cmd = "bash " .. file
  elseif ft == "lua" then
    cmd = "lua " .. file
  elseif ft == "java" then
    local filename = vim.fn.expand("%:t") -- MyClass.java
    local classname = vim.fn.expand("%:t:r") -- MyClass
    local filepath = vim.fn.expand("%:p") -- full path
    local dir = vim.fn.expand("%:p:h") -- directory of the file
    local outdir = dir .. "/out" -- compile output directory
    local fqcn = classname -- fallback to simple class name

    -- Check for main() method
    local has_main = false
    for line in io.lines(filepath) do
      if line:match("public%s+static%s+void%s+main%s*%(") then
        has_main = true
        break
      end
    end

    if not has_main then
      vim.notify("No main() method found in " .. filename, vim.log.levels.WARN)
      return
    end

    -- Check for package
    local package = nil
    for line in io.lines(filepath) do
      local pkg = line:match("^%s*package%s+([%w%.]+)%s*;")
      if pkg then
        package = pkg
        fqcn = pkg .. "." .. classname
        break
      end
    end

    -- Compile all .java files in the current folder recursively into `out`
    local compile_cmd = string.format("mkdir -p '%s' && javac -d '%s' $(find '%s' -name '*.java')", outdir, outdir, dir)
    -- Run the compiled file from out/ using the fully qualified class name
    local run_cmd = string.format("java -cp '%s' '%s'", outdir, fqcn)

    cmd = compile_cmd .. " && " .. run_cmd
  else
    vim.notify("Unsupported filetype: " .. ft, vim.log.levels.WARN)
    return
  end

  require("toggleterm.terminal").Terminal:new({ cmd = cmd, direction = "float", close_on_exit = false }):toggle()
end, { desc = "Run current file based on filetype" })
