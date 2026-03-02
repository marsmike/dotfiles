return {

  -- ── Tmux/nvim seamless navigation (C-hjkl across panes and splits) ───────────
  {
    'christoomey/vim-tmux-navigator',
    cmd = {
      'TmuxNavigateLeft', 'TmuxNavigateDown',
      'TmuxNavigateUp', 'TmuxNavigateRight',
    },
    keys = {
      { '<C-h>', '<cmd>TmuxNavigateLeft<cr>' },
      { '<C-j>', '<cmd>TmuxNavigateDown<cr>' },
      { '<C-k>', '<cmd>TmuxNavigateUp<cr>' },
      { '<C-l>', '<cmd>TmuxNavigateRight<cr>' },
    },
  },

  -- ── AI coding assistant (codecompanion — Claude via ANTHROPIC_API_KEY) ────────
  {
    'olimorris/codecompanion.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter' },
    opts = {
      strategies = {
        chat   = { adapter = 'anthropic' },
        inline = { adapter = 'anthropic' },
      },
    },
    keys = {
      { '<leader>ac', '<cmd>CodeCompanionChat Toggle<cr>',  desc = 'AI [C]hat' },
      { '<leader>aa', '<cmd>CodeCompanionActions<cr>',      desc = 'AI [A]ctions', mode = { 'n', 'v' } },
      { '<leader>ai', '<cmd>CodeCompanion<cr>',             desc = 'AI [I]nline', mode = { 'n', 'v' } },
      { 'ga',         '<cmd>CodeCompanionChat Add<cr>',     desc = 'Add to AI chat', mode = 'v' },
    },
  },

  -- ── Markdown rendering (inline, pairs well with Obsidian + codecompanion) ─────
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ft = { 'markdown', 'codecompanion' },
    opts = {},
  },

  -- ── File explorer (oil.nvim — edit filesystem like a buffer) ─────────────────
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      view_options = { show_hidden = true },
    },
    keys = {
      { '-', '<cmd>Oil<cr>', desc = 'Open file explorer' },
    },
  },

  -- ── Snacks (folke's quality-of-life collection) ───────────────────────────────
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = { enabled = true },  -- startup screen
      notifier  = { enabled = true },  -- better vim.notify
      bigfile   = { enabled = true },  -- disable heavy features for large files
      indent    = { enabled = true },  -- indent guides
      words     = { enabled = true },  -- highlight word under cursor
    },
  },

}
