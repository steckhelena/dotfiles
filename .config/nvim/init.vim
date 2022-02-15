" This automatically installs the vim-plug plugin manager if
" it is not already installed.
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

set encoding=utf-8
scriptencoding utf-8

" Initializing plugins
call plug#begin('~/.config/nvim/plugged')

" This colors html color codes
Plug 'norcalli/nvim-colorizer.lua'

" This enables using git commands from nvim
Plug 'tpope/vim-fugitive'

" This enables me using gcc to comment out a line or gc with a motion or
" in visual mode.
Plug 'tpope/vim-commentary'

" Add devicons
Plug 'kyazdani42/nvim-web-devicons'

" This is a tab bar for my buffers
Plug 'romgrk/barbar.nvim'

" This plugin automatically closes brackets after pressing return
Plug 'cohama/lexima.vim'

" This plugin automatically closes tags
Plug 'alvan/vim-closetag'

" This plugin automatically adjusts indent options based on file type
Plug 'tpope/vim-sleuth'

" This substitutes the standard vim directory browser with a better and more
" responsive alternative. I also binded it to toggle with <C-n> for faster browsing.
Plug 'scrooloose/nerdtree'

" This plugin shows git status on nerdtree
Plug 'Xuyuanp/nerdtree-git-plugin'

" This plugin allows me to use fzf, Ag or ripgrep to grep inside files
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" This changes automatically the root dir to the file I am working on
Plug 'airblade/vim-rooter'

" This gives me those sexy bars under my screen with all kinds of info.
Plug 'nvim-lualine/lualine.nvim'

" This plugin displays the line indentation for better visualization of code.
Plug 'lukas-reineke/indent-blankline.nvim'

" These are all plugins used for better syntax highlighting
Plug 'yuezk/vim-js'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'othree/html5.vim'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'jparise/vim-graphql'
Plug 'elzr/vim-json'
Plug 'neoclide/jsonc.vim'
Plug 'cespare/vim-toml'
Plug 'evanleck/vim-svelte'

" This plugin lets me use beautiful icons
Plug 'ryanoasis/vim-devicons'

" Use nvim-lsp as language server client
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'

" Lua lsp
Plug 'folke/lua-dev.nvim'

" Use nvim-cmp as autocomplete
Plug 'hrsh7th/nvim-cmp' 
Plug 'hrsh7th/cmp-nvim-lsp' 
Plug 'saadparwaiz1/cmp_luasnip' 
Plug 'L3MON4D3/LuaSnip' 
Plug 'hrsh7th/cmp-path'

" Use nvim-treesitter for better syntax trees
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" This adds a preview server to nvim for markdown files
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }

call plug#end()

set termguicolors

" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

set history=200		" keep 200 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set wildmenu		" display completion matches in a status line
set incsearch	" Do incremental searching.
set inccommand=nosplit " Shows live search and replace command changes(sexy)
set backupcopy=yes

" " This sets persistent undo
if !isdirectory(glob ($HOME . '/.config/nvim/undo'))
  " Creates undo directory if it does not exist
  call mkdir(glob ($HOME . '/.config/nvim/undo'), "p")
endif
set undofile                " Save undos after file closes
set undodir=$HOME/.config/nvim/undo " where to save undo histories
set undolevels=1000         " How many undos
set undoreload=10000        " number of lines to save for undo

" Indenting options
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=4

" Instead of failing a command raise a dialog asking for confirm on saving the
" file
set confirm

" Show linenumbers
set number
highlight LineNr ctermfg=grey
highlight LineNr ctermbg=None

" Show color column
set colorcolumn=81

lua << EOF
require'colorizer'.setup()
EOF

set ttimeout		" time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key

" Show @@@ in the last line if it is truncated.
set display=truncate

" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5

" Configuring my listchars to show characters which are invisible
set list
let &listchars="tab:> ,trail:-,nbsp:+,eol:↴"

" In many terminal emulators the mouse works just fine.
" Position the cursor, Visually select and scroll with the mouse.
if has('mouse')
  set mouse=a
endif

" Do not recognize octal numbers for Ctrl-A and Ctrl-X
set nrformats-=octal

" I like highlighting strings inside C comments.
let c_comment_strings=1


" Configuring the indent lines
let g:indent_blankline_char="|"
let g:indent_blankline_space_char_blankline=" "
let g:indent_blankline_show_trailing_blankline_indent = 0
let g:indent_blankline_show_end_of_line = 0

" Make ctrl-U and ctrl-W allow to undo changes
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>

"""
" nvim-lsp config
"""
lua << END
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pyright', 'clangd', 'tsserver', 'sumneko_lua' }
local lsp_installer_servers = require('nvim-lsp-installer.servers')

-- Loop through the servers listed above and set them up. If a server is
-- not already installed, install it.
for _, server_name in pairs(servers) do
  local server_available, server = lsp_installer_servers.get_server(server_name)

  if server_available then
    server:on_ready(function ()
    local opts = {
      on_attach = on_attach,
      capabilities = capabilities,
      flags = {
        -- This will be the default in neovim 0.7+
        debounce_text_changes = 150,
        }
      }

    if server_name == 'sumneko_lua' then
      opts = require("lua-dev").setup({lspconfig = opts})
    end

    server:setup(opts)
  end)

  if not server:is_installed() then
    server:install()
  end

end
end

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'path' },
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {
    enable = true
  },
}

END

" set foldmethod to use nvim treesitter
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevelstart=20

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" This lets me use C-b to build makefiles
nnoremap <C-b> :make<CR>

" This unsets the "last search pattern" register by hitting return
nnoremap <silent> <CR> :noh<CR><CR>

" This lets me use gb to switch buffers
nnoremap gb :ls<CR>:b<Space>

" This enables removing trailing whitespace from files using F5
nnoremap <silent> <F5> :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>

" This lets me write :cd to go to the current file's directory
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

" Status line configurations
lua << END
require'lualine'.setup()
END

" If barbar's option dict isn't created yet, create it
let bufferline = get(g:, 'bufferline', {})
let bufferline.auto_hide = v:true

" Lexima to only close like endwise or after pressing <CR>
let g:lexima_enable_endwise_rules = 1
let g:lexima_enable_newline_rules = 1
let g:lexima_enable_basic_rules = 0

" NERDTree config
let g:NERDTreeGitStatusUseNerdFonts = 1

" NERDTree mapping toggle with ctrl+n
map <C-n> :NERDTreeToggle<CR>

" This allows me to close a buffer without making NERDTree take up the whole
" window space
nnoremap \d :BufferClose<cr>
nnoremap <silent> <C-s>    :BufferPick<CR>

" Sets CtrlP to find root directory
let g:ctrlp_working_path_mode = 'ra'

" Makes json show quotes because that default config is quite dumb
let g:vim_json_syntax_conceal = 0

" Disables indentLine for markdown files, as it annoys the shit out of me this
" conceal setting
autocmd FileType markdown let g:indentLine_enabled = 0

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
" Revert with ":filetype off".
filetype plugin indent on

" Put these in an autocmd group, so that you can revert them with:
" ":augroup vimStartup | au! | augroup END"
augroup vimStartup
  au!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid, when inside an event handler
  " (happens when dropping a file on gvim) and for a commit message (it's
  " likely a different one than last time).
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    \ |   exe "normal! g`\""
    \ | endif

augroup END

" use tabs on Makefiles
autocmd FileType make set noexpandtab

" Sets rasi as a css file
autocmd BufNewFile,BufRead *.rasi   set syntax=css

" Sets python tabs to space in accord to PEP8
autocmd FileType python setlocal expandtab

" Opens NERDTree if no file was specified on launch
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Sets jsonc filetype
autocmd BufNewFile,BufRead *.jsonc set ft=jsonc

let path = expand('<sfile>:p:h')
exec 'source' path . '/theme.vim'

lua << EOF
local colorFile = vim.fn.expand('<sfile>:p:h').. '/theme.vim'
local function reload() 
	vim.cmd("source ".. colorFile)
end

local w = vim.loop.new_fs_event()
local on_change
local function watch_file(fname)
	w:start(fname, {}, vim.schedule_wrap(on_change))
end
on_change = function()
	reload()
	-- Debounce: stop/start.
	w:stop()
	watch_file(colorFile)
end

-- reload vim config when background changes
watch_file(colorFile)
reload()
EOF
