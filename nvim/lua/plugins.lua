return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  
  -- Add your plugins here, for example:
  use 'navarasu/onedark.nvim'  -- A theme
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
end)
