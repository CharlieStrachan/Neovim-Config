:set number
:set autoindent
:set tabstop=4
:set shiftwidth=4
:set smarttab
:set softtabstop=4

call plug#begin()

Plug 'https://github.com/vim-airline/vim-airline'
Plug 'nyoom-engineering/oxocarbon.nvim'
Plug 'https://github.com/windwp/nvim-autopairs'
Plug 'https://github.com/github/copilot.vim'

Plug 'iamcco/markdown-preview.nvim'

Plug 'neovim/nvim-lspconfig'

Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

call plug#end()

set background=dark
colorscheme oxocarbon

let g:copilot_no_tab_map = v:true
let g:copilot_no_enter_map = v:true

lua << EOF
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
EOF

lua << EOF
require("nvim-autopairs").setup {}
EOF

set completeopt=menu,menuone,noselect

lua << EOF
local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-Right>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'buffer' },
    { name = 'path' },
  })
})

vim.api.nvim_set_keymap("i", "<C-Right>", 'copilot#Accept("<CR>")', { expr = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-Up>", 'copilot#Next()', { expr = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-Down>", 'copilot#Previous()', { expr = true, silent = true })

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require('lspconfig').pyright.setup {
  capabilities = capabilities
}

require('lspconfig').marksman.setup {
  capabilities = capabilities
}

require('lspconfig').lua_ls.setup {
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
EOF
