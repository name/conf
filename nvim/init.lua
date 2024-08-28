-- nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Set basic options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.wrap = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.mouse = 'a'
vim.opt.undofile = true

-- Set leader key
vim.g.mapleader = ' '

-- Basic keymaps
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>', { desc = 'Save' })
vim.keymap.set('n', '<leader>q', '<cmd>quit<cr>', { desc = 'Quit' })
vim.keymap.set('n', '<leader>d', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>a', 'ggVG', {noremap = true})
vim.api.nvim_set_keymap('v', '<leader>c', '"+y', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>c', '"+yy', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-z>', 'u', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-z>', '<C-o>u', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-z>', '<Esc>u', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-y>', '<C-r>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-y>', '<C-o><C-r>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-y>', '<Esc><C-r>', { noremap = true, silent = true })

require('plugins')

-- Configure colorscheme
--require('onedark').load()
vim.cmd('colorscheme fullerene')


-- Configure Treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = { "lua", "vim", "vimdoc", "query" },
  highlight = { enable = true },
}

-- Configure Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

require('nvim-autopairs').setup({
  disable_filetype = { "TelescopePrompt" },
  disable_in_macro = false,  -- disable when recording or executing a macro
  disable_in_visualblock = false, -- disable when insert after visual block mode
  ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
  enable_moveright = true,
  enable_afterquote = true,  -- add bracket pairs after quote
  enable_check_bracket_line = true,  -- check bracket in same line
  enable_bracket_in_quote = true,
  break_undo = true, -- switch for basic rule break undo sequence
  check_ts = false,
  map_cr = true,
  map_bs = true,  -- map the <BS> key
  map_c_h = false,  -- Map the <C-h> key to delete a pair
  map_c_w = false, -- map <c-w> to delete a pair if possible
})

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

require("bufferline").setup({
  options = {
    mode = "buffers", -- set to "tabs" to only show tabpages instead
    numbers = "none", -- can be "none" | "ordinal" | "buffer_id" | "both"
    close_command = "bdelete! %d",       
    right_mouse_command = "bdelete! %d", 
    left_mouse_command = "buffer %d",    
    middle_mouse_command = nil,          
    indicator = {
        icon = '▎', -- this should be omitted if indicator style is not 'icon'
        style = 'icon' -- can also be 'underline'|'none',
    },
    buffer_close_icon = '',
    modified_icon = '●',
    close_icon = '',
    left_trunc_marker = '',
    right_trunc_marker = '',
    max_name_length = 18,
    max_prefix_length = 15,
    truncate_names = true,
    tab_size = 18,
    diagnostics = "nvim_lsp",
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      return "("..count..")"
    end,
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        highlight = "Directory",
        separator = true
      }
    },
  }
})

vim.api.nvim_set_keymap('n', '<Tab>', '<cmd>BufferLineCycleNext<cr>', {})
vim.api.nvim_set_keymap('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<cr>', {})


local alpha = require 'alpha'
local theme = require 'alpha.themes.dashboard'
theme.section.header.val =  {
    '                     .:::!~!!!!!:.',
    '                  .xUHWH!! !!?M88WHX:.',
    '                .X*#M@$!!  !X!M$$$$$$WWx:.',
    '               :!!!!!!?H! :!$!$$$$$$$$$$8X:',
    '              !!~  ~:~!! :~!$!#$$$$$$$$$$8X:',
    '             :!~::!H!<   ~.U$X!?R$$$$$$$$MM!',
    '             ~!~!!!!~~ .:XW$$$U!!?$$$$$$RMM!',
    '               !:~~~ .:!M"T#$$$$WX??#MRRMMM!',
    '               ~?WuxiW*`   `"#$$$$8!!!!??!!!',
    '             :X- M$$$$       `"T#$T~!8$WUXU~',
    '            :%`  ~#$$$m:        ~!~ ?$$$$$$',
    '          :!`.-   ~T$$$$8xx.  .xWW- ~""##*"',
    '.....   -~~:<` !    ~?T#$$@@W@*?$$      /`',
    'W$@@M!!! .!~~ !!     .:XUW$W!~ `"~:    :',
    '#"~~`.:x%`!!  !H:   !WM$$$$Ti.: .!WUn+!`',
    ':::~:!!`:X~ .: ?H.!u "$$$B$$$!W:U!T$$M~',
    '.~~   :X@!.-~   ?@WTWo("*$$$W$TH$! `',
    'Wi.~!X$?!-~   :: ?$$$B$Wu("**$RM!',
    '$R@i.~~ !    ::   ~$$$$$B$$en:``',
    '?MXT@Wx.~   ::     ~"##*$$$$M'
  }
  -- Set the header color to white
theme.section.header.opts = {
    position = "center",
    hl = "Comment"
}

-- Create a custom highlight group for white text
vim.api.nvim_set_hl(0, 'AlphaHeader', { fg = '#ffffff' })

-- Use the custom highlight for the header
theme.section.header.opts.hl = 'AlphaHeader'

alpha.setup(theme.config)

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = false,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}


