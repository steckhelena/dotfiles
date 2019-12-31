" This automatically installs the vim-plug plugin manager if
" it is not already installed.
if empty(glob('~/.config/nvim/autoload/plug.vim'))
	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Initializing plugins
call plug#begin('~/.config/nvim/plugged')
" This is a color scheme for my nvim
Plug 'mhartington/oceanic-next'

" This plugin enables me using cs'" substitute ' with "
" it also enables me to use ysiw" to surround a word with "
" and to use ds" to remove surrounding ", also works with tags
" and S in visual mode, yss" to surround whole line with ".
Plug 'tpope/vim-surround'

" This enables using git commands from nvim
Plug 'tpope/vim-fugitive'

" This enables me using gcc to comment out a line or gc with a motion or
" in visual mode.
Plug 'tpope/vim-commentary'

" This plugin automatically closes brackets after pressing return
Plug 'cohama/lexima.vim'

" This plugin automatically closes tags
Plug 'alvan/vim-closetag'

" This substitutes the standard vim directory browser with a better and more
" responsive alternative. I also binded it to toggle with <C-n> for faster browsing.
Plug 'scrooloose/nerdtree'

" This starts a fuzzy finder in the current root dir
Plug 'kien/ctrlp.vim'

" This changes automatically the root dir to the file I am working on
Plug 'airblade/vim-rooter'

" This gives me those sexy bars under my screen with all kinds of info.
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" This plugin displays the line indentation for better visualization of code.
Plug 'Yggdroot/indentLine'

" These are all plugins used for better syntax highlighting
Plug 'yuezk/vim-js'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'othree/html5.vim'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'jparise/vim-graphql'
Plug 'elzr/vim-json'

" This enables me using prettier for code fixing and formatting.
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }

" I use deoplete for autocomplete and ale for linting only(probably should
" change this in the future)
Plug 'dense-analysis/ale'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

call plug#end()

" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

set history=200		" keep 200 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set wildmenu		" display completion matches in a status line
set incsearch	" Do incremental searching.
set inccommand=nosplit " Shows live search and replace command changes(sexy)

" " This sets persistent undo
if !isdirectory('$HOME/.config/nvim/undo')
	" Creates undo directory if it does not exist
    call mkdir('$HOME/.config/nvim/undo', "p")
endif
set undofile                " Save undos after file closes
set undodir=$HOME/.config/nvim/undo " where to save undo histories
set undolevels=1000         " How many undos
set undoreload=10000        " number of lines to save for undo

" Indenting options
set tabstop=4
set shiftwidth=4
set softtabstop=0 noexpandtab

" Instead of failing a command raise a dialog asking for confirm on saving the
" file
set confirm

" Show linenumbers
set number
highlight LineNr ctermfg=grey
highlight LineNr ctermbg=None

set ttimeout		" time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key

" Show @@@ in the last line if it is truncated.
set display=truncate

" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5

" In many terminal emulators the mouse works just fine.
" Position the cursor, Visually select and scroll with the mouse.
if has('mouse')
	set mouse=a
endif

" Do not recognize octal numbers for Ctrl-A and Ctrl-X
set nrformats-=octal

" I like highlighting strings inside C comments.
let c_comment_strings=1

" This sets the OceanicNext as color theme
if (has("termguicolors"))
	set termguicolors
endif
syntax enable
colorscheme OceanicNext

" Make ctrl-U and ctrl-W allow to undo changes
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>

" This unsets the "last search pattern" register by hitting return
nnoremap <silent> <CR> :noh<CR><CR>

" This lets me use gb to switch buffers
nnoremap gb :ls<CR>:b<Space>

" This enables removing trailing whitespace from files using F5
nnoremap <silent> <F5> :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>

" This lets me write :cd to go to the current file's directory
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

" This enables me using tab in the ALE autocomplete
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-TAB>"

" Airline configurations
let g:airline_theme='oceanicnext'	" Using solarized theme
let g:airline_powerline_fonts = 1	" Uses the beautiful powerline fonts
let g:airline#extensions#tabline#enabled = 1	" Shows buffer tabline
let g:airline#extensions#tabline#buffer_nr_show = 1	" Shows buffer number in tabline
let g:airline#extensions#ale#enabled = 1 " Shows ALE errors and warning in tabline

" Lexima to only close like endwise or after pressing <CR>
let g:lexima_enable_endwise_rules = 1
let g:lexima_enable_newline_rules = 1
let g:lexima_enable_basic_rules = 0

" NERDTree mapping toggle with ctrl+n
map <C-n> :NERDTreeToggle<CR>

" This allows me to close a buffer without making NERDTree take up the whole
" window space
nnoremap \d :bp<cr>:bd #<cr>

" Sets CtrlP to find root directory
let g:ctrlp_working_path_mode = 'ra'

" Makes prettier execute on save and async
let g:prettier#exec_cmd_async = 1
let g:prettier#quickfix_enabled = 0
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html PrettierAsync

" Enables deoplete
let g:deoplete#enable_at_startup = 1

" Registers ALE as a deoplete autocomplete source
call deoplete#custom#source('ale', 'dup', v:false)

" Disables ale autocomplete
let g:ale_completion_enabled = 0

" Enables some fixers for ale
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['prettier', 'eslint'],
\   'typescript': ['prettier', 'eslint'],
\}

" Enables autoimport for ts files
let g:ale_completion_tsserver_autoimport = 1

" Set this variable to 1 to fix files when you save them.
let g:ale_fix_on_save = 1

" Makes json show quotes because that default config is quite dumb
let g:vim_json_syntax_conceal = 0

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

" Sets rasi as a css file
autocmd BufNewFile,BufRead *.rasi   set syntax=css

" Sets python tabs to space in accord to PEP8
autocmd FileType python setlocal expandtab

" Opens NERDTree if no file was specified on launch
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Sets jsonc filetype
autocmd BufNewFile,BufRead *.jsonc set ft=jsonc
