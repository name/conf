return require('packer').startup(function(use)
use 'wbthomason/packer.nvim'
  
  -- Add your plugins here, for example:
use {
  'steguiosaur/fullerene.nvim',
  config = function()
    -- Optional: Add any configuration here if needed
    vim.cmd('colorscheme fullerene')
  end
}
use {
  'nvim-tree/nvim-tree.lua',
  requires = {
    'nvim-tree/nvim-web-devicons', -- optional, for file icons
  },
}
  use 'navarasu/onedark.nvim'  -- A theme
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  
  use {
  'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-buffer', -- Buffer completions
      'hrsh7th/cmp-path', -- Path completions
      'hrsh7th/cmp-cmdline', -- Cmdline completions
      'hrsh7th/cmp-nvim-lsp', -- LSP completions
      'L3MON4D3/LuaSnip', -- Snippet engine
      'saadparwaiz1/cmp_luasnip' -- Snippet completions
    }
  }
use {
    'windwp/nvim-autopairs',
    config = function() require("nvim-autopairs").setup {} end
}
use {'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons'}
end)
