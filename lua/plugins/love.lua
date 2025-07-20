return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT", -- Love2D uses LuaJIT
              },
              diagnostics = {
                globals = { "vim", "love" }, -- Add `love` as a recognized global
              },
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                },
              },
              telemetry = {
                enable = false,
              },
            },
          },
        },
      },
    },
  },
}
