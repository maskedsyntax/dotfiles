-- init.lua

-- Install Packer (if you haven't already)
vim.cmd([[packadd packer.nvim]])

require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    -- File Tree
    use {
        'kyazdani42/nvim-tree.lua',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function()
            require'nvim-tree'.setup {
                -- Add your custom configurations here if needed
            -- view = {
            --    mappings = {
            --      list = {
            --        { key = "v", action = "vsplit" }, -- Open in vertical split
            --        { key = "s", action = "split" },  -- Open in horizontal split
            --        { key = "t", action = "tabnew" }, -- Open in new tab
            --      }
            --    }
            --  }
            }
        end
    }
    -- Themes
    -- Gruvbox
    use 'gruvbox-community/gruvbox'
    -- One Dark
    -- use {
    --     'navarasu/onedark.nvim',
    --     config = function()
    --         require('onedark').setup {
    --             style = 'darker' -- Options: 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'
    --         }
    --         require('onedark').load()
    --     end
    -- }
    -- Catppuccin
    -- use {
    --     'catppuccin/nvim',
    --     as = 'catppuccin',
    --     config = function()
    --         require('catppuccin').setup()
    --         -- vim.cmd('colorscheme catppuccin')
    --     end
    -- }

    -- VSCode
    use {
        'Mofiqul/vscode.nvim',
        config = function()
            vim.cmd('colorscheme vscode')
        end
    }

    -- Github Theme
    -- use {
    --     'projekt0n/github-nvim-theme',
    --     config = function()
    --         require('github-theme').setup()
    --         vim.cmd('colorscheme github_dark') -- or 'github_light'
    --     end
    -- }
    -- Dracula theme
    -- use {
    --     'dracula/vim',
    --     as = 'dracula',
    --     config = function()
    --         vim.cmd('colorscheme dracula')
    --     end
    -- }

    -- use 'hoob3rt/lualine.nvim'
    -- Lualine
    use {
        'hoob3rt/lualine.nvim',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function()
            require('lualine').setup {
                options = {
                    icons_enabled = true,
                    theme = 'vscode', -- Use the VSCode theme for lualine
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
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
            
            -- Optional: Customize lualine colors to better match VSCode Dark Theme
            vim.cmd[[hi LualineNormal guibg=NONE guifg=#d4d4d4]]
            vim.cmd[[hi LualineNormalNC guibg=NONE guifg=#d4d4d4]]
        end
    }

    -- use 'romgrk/barbar.nvim'
    -- Barbar.nvim for tab management
    use {
        'romgrk/barbar.nvim',
        requires = 'kyazdani42/nvim-web-devicons', -- optional, for file icons
        config = function()
            require'bufferline'.setup {
                -- Enable icons and set offsets for the nvim-tree
                options = {
                    separator_style = "slant", -- or "thick" | "thin" | "padded_slant"
                    offsets = {{
                        filetype = "NvimTree",
                        text = "File Explorer",
                        highlight = "Directory",
                        text_align = "center",
                        padding = 1,
                    }},
                    -- other bufferline settings...
                    enforce_regular_tabs = true,
                    always_show_bufferline = false,
                }
            }

            -- Key mappings for buffer navigation
            vim.api.nvim_set_keymap('n', '<A-,>', ':BufferPrevious<CR>', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<A-.>', ':BufferNext<CR>', { noremap = true, silent = true })
            -- Move buffers
            vim.api.nvim_set_keymap('n', '<A-<>', ':BufferMovePrevious<CR>', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<A->>', ':BufferMoveNext<CR>', { noremap = true, silent = true })
            -- Close buffer
            vim.api.nvim_set_keymap('n', '<A-c>', ':BufferClose<CR>', { noremap = true, silent = true })
        end
    }
    -- Autocompletion
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-cmdline',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip'
        },
        config = function()
            local cmp = require'cmp'
            cmp.setup {
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                }, {
                    { name = 'buffer' },
                })
            }
        end
    }
    
    
    -- Telescope
    use {
        'nvim-telescope/telescope.nvim',
        requires = { {'nvim-lua/plenary.nvim'} },
        config = function()
            require('telescope').setup{
                defaults = {
                    vimgrep_arguments = {
                        'rg',
                        '--color=never',
                        '--no-heading',
                        '--with-filename',
                        '--line-number',
                        '--column',
                        '--smart-case'
                    },
                    prompt_prefix = "> ",
                    selection_caret = "> ",
                    entry_prefix = "  ",
                    initial_mode = "insert",
                    selection_strategy = "reset",
                    sorting_strategy = "ascending",
                    layout_strategy = "horizontal",
                    layout_config = {
                        horizontal = {
                            mirror = false,
                        },
                        vertical = {
                            mirror = false,
                        },
                    },
                    file_sorter =  require'telescope.sorters'.get_fuzzy_file,
                    file_ignore_patterns = {},
                    generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
                    path_display = {},
                    winblend = 0,
                    border = {},
                    borderchars = {'─', '│', '─', '│', '╭',
                                        '╮', '╯', '╰'},
                    color_devicons = true,
                    use_less = true,
                    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
                    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
                    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
                    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

                    -- Developer configurations: Not meant for general override
                    buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
                }
            }

            -- Keybindings for Telescope
            vim.api.nvim_set_keymap('n', '<C-f>', '<cmd>Telescope find_files<CR>', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<C-g>', '<cmd>Telescope live_grep<CR>', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<Leader><Tab>', '<cmd>Telescope buffers<CR>', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<Leader>fh', '<cmd>Telescope help_tags<CR>', { noremap = true, silent = true })
        end
    }

    -- LSP
    use 'neovim/nvim-lspconfig'
    
    -- C++ LSP (clangd)
    require('lspconfig').clangd.setup{
        on_attach = function(client, bufnr)
            -- Your on_attach configuration here
        end,
        flags = {
            debounce_text_changes = 150,
        },
        cmd = { "clangd", "--background-index", "--clang-tidy", "--completion-style=detailed" },
        filetypes = { "c", "cpp", "objc", "objcpp" },
        root_dir = require('lspconfig').util.root_pattern("compile_commands.json", ".git"),
        init_options = {
            clangd = {
                clangdPath = "/usr/bin/clangd",
                extraArgs = { "-I/usr/include/python3.12" }
            }
        },
    }
    
    -- Treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require'nvim-treesitter.configs'.setup {
                ensure_installed = "cpp", -- List of parsers to install
                highlight = {
                    enable = true,
                },
            }
        end
    }
end)

-- Define function to close NvimTree if it's the only window
function CloseNvimTreeIfOnlyWindow()
    local nvim_tree_exists = false
    local windows = vim.api.nvim_list_wins()

    for _, win in ipairs(windows) do
        local buf = vim.api.nvim_win_get_buf(win)
        local buf_name = vim.api.nvim_buf_get_name(buf)
        if buf_name:match("NvimTree") then
            nvim_tree_exists = true
        end
    end

    if nvim_tree_exists and #windows == 1 then
        vim.cmd("quit")  -- Close the only window, which is NvimTree
    end
end

-- Map <Leader>q to close NvimTree if it's the only window
vim.api.nvim_set_keymap('n', '<Leader>q', '<cmd>lua CloseNvimTreeIfOnlyWindow()<CR>', { noremap = true, silent = true })

-- Automatically close NvimTree if it's the only window left
vim.api.nvim_create_autocmd('BufEnter', {
    pattern = '*',
    callback = CloseNvimTreeIfOnlyWindow,
})


-- Basic settings
-- Set <Leader> to space
vim.g.mapleader = ' '
vim.o.number = true
vim.o.relativenumber = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.smartindent = true
vim.o.wrap = false
-- Set clipboard to unnamedplus
vim.opt.clipboard = 'unnamedplus'

-- Map <Esc> to jk
vim.api.nvim_set_keymap('i', 'jk', '<Esc>', { noremap = true, silent = true })

-- Keybindings for LSP diagnostics
vim.api.nvim_set_keymap('n', '<leader>w', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dn', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dp', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })

-- Visual mode indentation mappings
vim.api.nvim_set_keymap('x', '<', '<gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '>', '>gv', { noremap = true, silent = true })


-- Keybinding for Nvim Tree
vim.api.nvim_set_keymap('n', '<Leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Set up LSP for C++
local lspconfig = require('lspconfig')
lspconfig.clangd.setup {
    cmd = { "clangd", "--background-index", "--clang-tidy", "--completion-style=detailed" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    root_dir = lspconfig.util.root_pattern("compile_commands.json", ".git"),
}

-- Enable autocompletion
local cmp = require'cmp'
local luasnip = require'luasnip'

-- Set up auto-completion
-- vim.o.completeopt = 'menuone,noselect'

-- Apply theme
vim.cmd('colorscheme vscode')

-- Set background transparency
-- Enable transparency for gruvbox
-- vim.g.gruvbox_transparent_bg = 1
-- 
vim.cmd[[hi Normal guibg=NONE ctermbg=NONE]]
vim.cmd[[hi NonText guibg=NONE ctermbg=NONE]]
vim.cmd[[hi SignColumn guibg=NONE]]
vim.cmd[[hi EndOfBuffer guibg=NONE]]

