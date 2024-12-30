-- Remove S so that it doesn't conflict with surround
vim.keymap.set({ 'n', 'x', 'v' }, 's', '<Nop>')
vim.keymap.set({ 'n', 'x', 'v' }, 'S', '<Nop>')

-- Remove gc so that it doesn't conflict with minicomment manual set up
vim.keymap.set({ 'n', 'x', 'v' }, 'gc', '<Nop>')

--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true
-- mouse mode
vim.opt.mouse = 'a'
-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false
vim.opt.shiftwidth = 4

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 5

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', 'H', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', 'L', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-Left>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-Right>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to force a plugin to be loaded.
  --

  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`. This is equivalent to the following Lua:
  --    require('gitsigns').setup({ ... })
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `config` key, the configuration only runs
  -- after the plugin has been loaded:
  --  config = function() ... end

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default whick-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      preset = 'helix',
      spec = {
        { '<leader>f', group = '[F]ind' },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>l', group = '[L]SP' },
        -- { '<leader>b', group = '[B]ookmarks' },
        { '<leader>a', group = '[A]ctions' },
        { '<leader>g', group = '[G]it', mode = { 'n', 'v' } },
        { '<leader>n', group = '[N]eotree' },
      },
    },
  },
  {
    'jacob-bayer/nvim-dbee',
    branch = 'bigquery-fix',
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
    build = function()
      -- Install tries to automatically detect the install method.
      -- if it fails, try calling it with one of these parameters:
      --    "curl", "wget", "bitsadmin", "go"
      require('dbee').install 'go'
    end,
    config = function()
      require('dbee').setup(--[[optional config]])
    end,
  },
  { 'natecraddock/workspaces.nvim', opts = {
    cd_type = 'tab',
    hooks = {
      open = { 'tabnew', 'Neotree reveal' },
    },
  } },
  { 'natecraddock/sessions.nvim' },

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
      'debugloop/telescope-undo.nvim',
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
    config = function()
      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      local themes = require 'telescope.themes'
      local telescope = require 'telescope'
      local builtin = require 'telescope.builtin'

      telescope.setup {
        defaults = {
          initial_mode = 'normal',
          winblend = 10,
        },
        path_display = { truncate = 3 },
        pickers = { registers = { layout_config = { anchor = 'SE' } } },
        extensions = { ['ui-select'] = { themes.get_dropdown() }, undo = { use_delta = false }, workspaces = {} },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local undo = telescope.load_extension 'undo'
      local works = telescope.load_extension 'workspaces'
      local harpoon = telescope.load_extension 'harpoon'

      -- See `:help telescope.builtin`
      vim.keymap.set('n', '<leader>fht', builtin.help_tags, { desc = '[F]ind [H]elp' })
      vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps' })
      vim.keymap.set('n', '<leader>fF', builtin.find_files, { desc = '[F]ind [F]iles by name' })
      vim.keymap.set('n', '<leader>fs', builtin.builtin, { desc = '[F]ind Telescope features' })
      vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[F]ind current [W]ord' })
      vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
      vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = '[F]ind [R]ecent Files' })
      vim.keymap.set('n', '<leader><leader>', builtin.resume, { desc = '[ ] Resume most recent Telescope' })
      vim.keymap.set('n', '<leader>fu', undo.undo, { desc = '[U]ndo history' })
      vim.keymap.set('n', '-', builtin.buffers, { desc = 'Open buffers' })
      vim.keymap.set('n', '<leader>hf', harpoon.marks, { desc = 'Harpoon marks' })

      -- Git
      vim.keymap.set('n', '<leader>gh', builtin.git_bcommits, { desc = 'Browse commit history of current file' })
      vim.keymap.set('n', '<leader>gl', builtin.git_branches, { desc = 'Browse git branches' })
      vim.keymap.set('n', '<leader>fc', builtin.git_commits, { desc = 'Find git commits' })

      vim.keymap.set('n', '`', function()
        builtin.marks(themes.get_dropdown())
      end, { desc = 'Bookmarks' })

      vim.keymap.set('n', '<leader>fc', function()
        builtin.colorscheme(themes.get_dropdown { previewer = false, enable_preview = true })
      end, { desc = '[F]ind [C]olorschemes' })

      vim.keymap.set({ 'n', 'v', 'x', 'o' }, "'", function()
        builtin.registers(themes.get_dropdown { previewer = false })
      end, { desc = 'Registers' })

      vim.keymap.set('n', '<leader>lq', function()
        builtin.quickfix(themes.get_dropdown { previewer = false })
      end, { desc = 'Quickfixes' })

      vim.keymap.set('n', '<leader>fz', function()
        builtin.current_buffer_fuzzy_find(themes.get_dropdown { previewer = false })
      end, { desc = 'Fu[z]zily search in current buffer' })

      vim.keymap.set('n', '<leader>/', function()
        builtin.live_grep {
          prompt_title = 'Searching in current buffer',
          search_dirs = { vim.fn.expand '%:p' },
          path_display = 'hidden',
          initial_mode = 'insert',
        }
      end, { desc = 'Search in current buffer' })

      vim.keymap.set('n', '=', function()
        works.workspaces(themes.get_dropdown { previewer = false })
      end, { desc = 'Show workspaces' })

      vim.keymap.set('n', '<leader>fH', function()
        undo.undo { prompt_title = 'Save history for current file', saved_only = true }
      end, { desc = 'Local history' })

      vim.keymap.set('n', '<leader>fhf', function()
        builtin.live_grep {
          prompt_title = 'Live grep for help files',
          cwd = vim.fn.stdpath 'data',
          type_filter = 'txt',
        }
      end, { desc = 'Fuzzy search helpdocs' })

      vim.keymap.set('n', '<leader>ff', function()
        builtin.live_grep {
          prompt_title = 'Searching in (' .. vim.fn.getcwd() .. ')',
        }
      end, { desc = 'Search in current working directory' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>fn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },
  {
    'benlubas/molten-nvim',
    dependencies = { '3rd/image.nvim' },
    build = ':UpdateRemotePlugins',
    init = function()
      vim.g.molten_image_provider = 'image.nvim'
      vim.g.molten_use_border_highlights = true
      vim.keymap.set('n', '<localleader>mi', ':MoltenInit<CR>')
      vim.keymap.set('n', '<localleader>s', ':MoltenEvaluateOperator<CR>')
      vim.keymap.set('n', '<localleader>r', ':MoltenReevaluateCell<CR>')
      vim.keymap.set('v', '<localleader>s', ':<C-u>MoltenEvaluateVisual<CR>gv')
      vim.keymap.set('n', '<localleader>os', ':noautocmd MoltenEnterOutput<CR>')
      vim.keymap.set('n', '<localleader>oh', ':MoltenHideOutput<CR>')
      vim.keymap.set('n', '<localleader>md', ':MoltenDelete<CR>')
    end,
  },
  {
    'nvimdev/lspsaga.nvim',
    config = function()
      require('lspsaga').setup {
        ui = { code_action = '' },
      }
    end,
    dependencies = {
      -- 'nvim-treesitter/nvim-treestitter',
      'nvim-tree/nvim-web-devicons',
    },
  },
  { 'tpope/vim-dadbod' },
  {
    'kristijanhusak/vim-dadbod-ui',
    ft = { 'sql' },
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql' }, lazy = true },
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_execute_on_save = 0
      vim.g.db_ui_disable_mappings_sql = 1
    end,
    config = function()
      vim.keymap.set({ 'n' }, '<leader>s', ':normal vas<CR><Plug>(DBUI_ExecuteQuery)', { desc = 'Execute query' })
      vim.keymap.set({ 'v' }, '<leader>s', '<Plug>(DBUI_ExecuteQuery)', { desc = 'Execute query' })
      vim.keymap.set({ 'n' }, '<leader>w', '<Plug>(DBUI_SaveQuery)', { desc = 'Save query' })
      vim.keymap.set({ 'n' }, '<leader>e', '<Plug>(DBUI_EditBindParameters)', { desc = 'Edit bind parameters' })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'dbout' },
        callback = function()
          vim.wo.foldenable = false
        end,
      })
    end,
  },
  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by nvim-cmp
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          local ts = require 'telescope.builtin'

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('gd', ts.lsp_definitions, '[G]oto [D]efinition')
          -- map('gd', '<cmd>Lspsaga peek_definition<CR>', '[G]oto [D]efinition')

          -- Find references for the word under your cursor.
          map('gr', ts.lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', ts.lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('gt', '<cmd>Lspsaga peek_type_definition<CR>', 'Peek [t]ype definition')
          map('gT', ts.lsp_type_definitions, '[T]ype definition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>ld', ts.lsp_document_symbols, '[D]ocument [S]ymbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('<leader>lw', ts.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>lr', vim.lsp.buf.rename, '[R]ename')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>la', vim.lsp.buf.code_action, 'Code [A]ction', { 'n', 'x' })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        -- clangd = {},
        basedpyright = {},
        vimls = {},
        stylelint_lsp = {},
        sqlls = {},
        prettierd = {},
        gopls = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`ts_ls`) will work just fine
        -- ts_ls = {},
        --

        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu.
      require('mason').setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<C-A-l>',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = 'Format buffer',
      },
    },
    opts = {
      -- log_level = vim.log.levels.DEBUG,
      notify_on_error = true,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = 'never'
        else
          lsp_format_opt = 'fallback'
        end
        return {
          timeout_ms = 500,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        python = { 'black' },
        sql = { 'sqlls', 'sqlint' },
        css = { 'stylelint', 'stylelint-lsp' },
        json = { 'prettierd' },
        -- You can use 'stop_after_first' to run the first available formatter from the list
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        go = { 'goimports' },
      },
    },
  },
  {
    'ThePrimeagen/harpoon',
    -- branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'
      harpoon.setup {}

      vim.keymap.set('n', '<leader>ha', function()
        require('harpoon.mark').add_file()
      end)
      -- vim.keymap.set('n', '<C-e>', function()
      --   harpoon.ui:toggle_quick_menu(harpoon:list())
      -- end)

      -- vim.keymap.set('n', '<C-h>', function()
      --   harpoon:list():select(1)
      -- end)
      -- vim.keymap.set('n', '<C-j>', function()
      --   harpoon:list():select(2)
      -- end)
      -- vim.keymap.set('n', '<C-k>', function()
      --   harpoon:list():select(3)
      -- end)
      -- vim.keymap.set('n', '<C-l>', function()
      --   harpoon:list():select(4)
      -- end)

      -- Toggle previous & next buffers stored within Harpoon list
      -- vim.keymap.set('n', '<C-S-P>', function()
      --   harpoon:list():prev()
      -- end)
      -- vim.keymap.set('n', '<C-S-N>', function()
      --   harpoon:list():next()
      -- end)

      -- basic telescope configuration
      -- local conf = require('telescope.config').values
      -- local function toggle_telescope(harpoon_files)
      --   local file_paths = {}
      --   for _, item in ipairs(harpoon_files.items) do
      --     table.insert(file_paths, item.value)
      --   end
      --
      --   require('telescope.pickers')
      --     .new({}, {
      --       prompt_title = 'Harpoon',
      --       finder = require('telescope.finders').new_table {
      --         results = file_paths,
      --       },
      --       previewer = conf.file_previewer {},
      --       sorter = conf.generic_sorter {},
      --     })
      --     :find()
      -- end
      --
      -- vim.keymap.set('n', '<C-e>', function()
      --   toggle_telescope(harpoon:list())
      -- end, { desc = 'Open harpoon window' })
    end,
  },
  -- TODO: Setup config with good keymaps. It already has built in functionality to enable certain keymaps in diff mode and not otherwise.
  -- https://github.com/sindrets/diffview.nvim?tab=readme-ov-file#configuration
  -- Also vims native diff mode seems to be pretty good
  { 'sindrets/diffview.nvim' },
  { 'github/copilot.vim' },
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation window [b]ack / [f]orward
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ['<C-y>'] = cmp.mapping.confirm { select = true },

          -- If you prefer more traditional completion keymaps,
          -- you can uncomment the following lines
          --['<CR>'] = cmp.mapping.confirm { select = true },
          --['<Tab>'] = cmp.mapping.select_next_item(),
          --['<S-Tab>'] = cmp.mapping.select_prev_item(),

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },
        sources = {
          {
            name = 'lazydev',
            -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
            group_index = 0,
          },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'vim-dadbod-completion' },
          { name = 'buffer' },
        },
      }
    end,
  },
  { 'nvim-pack/nvim-spectre' },
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'tokyonight'

      -- You can configure highlights by doing something like:
      vim.cmd.hi 'Comment gui=none'
    end,
    opts = {
      style = 'moon',
      light_style = 'day',
      styles = {
        comments = { italic = false },
        keywords = { italic = false },
        functions = { italic = false },
        variables = { italic = false },
        sidebars = 'dark',
        floats = 'dark',
      },
      day_brightness = 0.3,
      lualine_bold = false,
    },
  },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  { 'tpope/vim-fugitive' },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      require('mini.comment').setup {
        mappings = {
          comment = '',
          comment_line = 'gcc',
          comment_visual = '|',
          textobject = '',
        },
      }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },

  -- The following two comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  require 'kickstart.plugins.debug',
  require 'kickstart.plugins.indent_line',
  require 'kickstart.plugins.lint',
  require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.neo-tree',
  -- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
  -- { import = 'custom.plugins' },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

vim.keymap.set('n', '<leader>ac', ':cd %:h<CR>', { desc = 'Chdir to current buffer' })
vim.keymap.set('n', '<leader>ag', ':echo getcwd()<CR>', { desc = 'Get current buffer' })
vim.keymap.set('v', '<leader>ar', function()
  vim.cmd.normal { '"zy' }
  local selection = vim.fn.getreg 'z'
  vim.cmd.lua { selection }
  -- not sure how to get this to work
  -- print('="' .. selection .. '"')
  -- vim.cmd.lua { '=print("' .. selection ..'")' }
end, { desc = '[R]un selection in Lua' })

vim.keymap.set('v', '<leader>ae', function()
  vim.cmd.normal { '"zy', bang = true }
  local selection = vim.fn.getreg 'z'
  vim.cmd.lua { '=' .. selection }
end, { desc = '[E]cho selection in Lua' })

vim.keymap.set({ 'n', 'v', 'x', 'o' }, 'E', '$')
vim.keymap.set({ 'n', 'v', 'x', 'o' }, 'B', '^')
vim.keymap.set('n', '<C-Up>', '<cmd>Gitsigns prev_hunk<CR>:Gitsigns preview_hunk<CR>')
vim.keymap.set('n', '<C-Down>', '<cmd>Gitsigns next_hunk<CR>:Gitsigns preview_hunk<CR>')
vim.keymap.set('n', '<C-Down>', '<cmd>Gitsigns next_hunk<CR>:Gitsigns preview_hunk<CR>')
vim.keymap.set('n', '<A-h>', '<cmd>tabprevious<CR>')
vim.keymap.set('n', '<A-l>', '<cmd>tabnext<CR>')
vim.keymap.set('n', '<A-Left>', '<cmd>tabprevious<CR>')
vim.keymap.set('n', '<A-1>', '<cmd>1tabnext<CR>')
vim.keymap.set('n', '<A-2>', '<cmd>2tabnext<CR>')
vim.keymap.set('n', '<A-3>', '<cmd>3tabnext<CR>')
vim.keymap.set('n', '<A-4>', '<cmd>4tabnext<CR>')
vim.keymap.set('n', '<A-5>', '<cmd>5tabnext<CR>')
vim.keymap.set('n', '<A-6>', '<cmd>6tabnext<CR>')
vim.keymap.set('n', '<A-7>', '<cmd>7tabnext<CR>')
vim.keymap.set('n', '<A-8>', '<cmd>8tabnext<CR>')

vim.keymap.set('n', '<A-K>', ':resize -1<CR>')
vim.keymap.set('n', '<A-J>', ':resize +1<CR>')
vim.keymap.set('n', '<A-L>', ':vertical resize +1<CR>')
vim.keymap.set('n', '<A-H>', ':vertical resize -1<CR>')

vim.keymap.set('n', '<leader>Q', ':confirm bd', { desc = 'Close this buffer without saving' })
vim.keymap.set('n', '<leader>q', ':w:bd<CR>', { desc = 'Write and close this buffer' })

vim.keymap.set('n', '<leader>dg', ':diffg<CR>Vkk:foldopen<CR>', { desc = 'diff foldopen or something' })
vim.keymap.set('n', '<leader>as', ':e $MYVIMRC<CR>', { desc = 'Edit [S]ource ($MYVIMRC)' })
vim.keymap.set('n', '<leader>az', ':e ~/.zshrc<CR>', { desc = 'Edit ~/.zshrc' })
vim.keymap.set('n', '<leader>ap', ':e ~/.p10k.zsh<CR>', { desc = 'Edit ~/.p10k.zsh' })
vim.keymap.set('n', '<leader>ah', ':e ~/.config/hypr/hyprland.conf<CR>', { desc = 'Edit hyprland.conf' })

vim.keymap.set('n', 'M', 'i<CR><ESC>')

-- Doesn't work below. Needs to keep text highlighted.
-- vim.keymap.set({'n','v'}, '<Tab>', '<cmd>><CR>')
-- vim.keymap.set({'n','v'}, '<S-Tab>', '<cmd><<CR>')

-- vim.keymap.set('n' , '<leader>ad', ':WorkspacesOpen nvim-pkgs<CR>' , {desc = 'Edit package installations'})
vim.keymap.set('n', '<leader>T', vim.cmd.tabnew, { desc = 'New tab' })
vim.keymap.set('v', 'p', '"0p')
vim.keymap.set('v', 'P', '"0P')

vim.keymap.set('n', '<leader>V', vim.cmd.vsplit, { desc = 'Vsplit' })
vim.keymap.set('n', '<leader>L', vim.cmd.Lazy, { desc = 'Show Lazy package manager' })

vim.keymap.set('n', '<leader>lM', vim.cmd.Mason, { desc = 'Open Mason' })
-- vim.keymap.set('n', '<leader>lfs', ':e $FORMATTER_HOME/.sql-formatter.json<CR>', {desc = 'sql-formatter'})

-- vim.keymap.set({ 'n', 'v', 'x', 'o' }, '<leader>zo', ':foldopen<CR>')
-- vim.keymap.set({ 'n', 'v', 'x', 'o' }, '<leader>zc', ':fold<CR>')
vim.keymap.set('n', '<C-a>', 'gg<S-v>G', { desc = 'Select all' })
vim.keymap.set('n', '|', ':normal gcc<CR><Down>', { desc = 'Comment line', silent = true })

-- Gitsigns section
local gitsigns = require 'gitsigns'

-- Stage/reset hunk
vim.keymap.set('n', '<leader>gc', ':Neotree git_status<CR>', { desc = 'Show neotree git status', silent = true })
vim.keymap.set('n', '<leader>gs', gitsigns.stage_hunk, { desc = 'Stage hunk' })
vim.keymap.set('n', '<leader>gr', gitsigns.reset_hunk, { desc = 'Reset hunk' })
vim.keymap.set('v', '<leader>gs', function()
  gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
end, { desc = 'Stage hunk' })
vim.keymap.set('v', '<leader>gr', function()
  gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
end, { desc = 'Reset hunk' })

vim.keymap.set('n', '<leader>gu', gitsigns.undo_stage_hunk, { desc = 'Undo stage hunk' })

-- Stage/reset buffer
vim.keymap.set('n', '<leader>gS', gitsigns.stage_buffer, { desc = 'Stage buffer' })
vim.keymap.set('n', '<leader>gR', gitsigns.reset_buffer, { desc = 'Reset buffer' })
vim.keymap.set('n', '<leader>gp', gitsigns.preview_hunk, { desc = 'Preview hunk' })

-- Blame
vim.keymap.set('n', '<leader>gbb', gitsigns.blame, { desc = 'Toggle blame annotations' })
vim.keymap.set('n', '<leader>gbi', gitsigns.toggle_current_line_blame, { desc = 'Toggle inline blame' })
vim.keymap.set('n', '<leader>gbl', ':Git blame<CR>', { desc = 'Toggle fugitive blame' })

-- Diff
vim.keymap.set('n', '<leader>gd', vim.cmd.DiffviewOpen, { desc = 'Diffview' })
vim.keymap.set('n', '<leader>gD', function()
  gitsigns.diffthis '~'
end, { desc = 'Diff this' })
vim.keymap.set('n', '<leader>gt', gitsigns.toggle_deleted, { desc = 'Toggle deletions' })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
