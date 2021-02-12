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

" This enables using git commands from nvim
Plug 'tpope/vim-fugitive'

" This enables me using gcc to comment out a line or gc with a motion or
" in visual mode.
Plug 'tpope/vim-commentary'

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
Plug 'neoclide/jsonc.vim'
Plug 'cespare/vim-toml'

" This plugin lets me use beautiful icons
Plug 'ryanoasis/vim-devicons'

" Use coc as language server client
let g:coc_global_extensions = [
      \'coc-actions',
      \'coc-clangd',
      \'coc-cmake',
      \'coc-css',
      \'coc-eslint',
      \'coc-git',
      \'coc-html',
      \'coc-prettier', 
      \'coc-pyright',
      \'coc-tsserver',
      \'coc-vimlsp', 
      \'coc-xml',
      \'coc-yaml',
\]
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" This adds a preview server to nvim for markdown files
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }

call plug#end()

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

"""
" Coc.nvim configurations
"""
" Enable using tab to activate completion
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

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

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if has('patch8.1.1068')
  " Use `complete_info` if your (Neo)Vim version supports it.
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Format selecttion
nmap <leader>f  <Plug>(coc-format-selected)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for do codeAction of selected region
function! s:cocActionsOpenFromSelected(type) abort
  execute 'CocCommand actions.open ' . a:type
endfunction
xmap <silent> <leader>a :<C-u>execute 'CocCommand actions.open ' . visualmode()<CR>
nmap <silent> <leader>a :<C-u>set operatorfunc=<SID>cocActionsOpenFromSelected<CR>g@

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Sets up the ":Prettier" command
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

"""

" This unsets the "last search pattern" register by hitting return
nnoremap <silent> <CR> :noh<CR><CR>

" This lets me use gb to switch buffers
nnoremap gb :ls<CR>:b<Space>

" This enables removing trailing whitespace from files using F5
nnoremap <silent> <F5> :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>

" This lets me write :cd to go to the current file's directory
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

" Airline configurations
let g:airline_theme='oceanicnext'	" Using solarized theme
let g:airline_powerline_fonts = 1	" Uses the beautiful powerline fonts
let g:airline#extensions#tabline#enabled = 1	" Shows buffer tabline
let g:airline#extensions#tabline#buffer_nr_show = 1	" Shows buffer number in tabline

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
nnoremap \d :bp<cr>:bd #<cr>

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

" Sets rasi as a css file
autocmd BufNewFile,BufRead *.rasi   set syntax=css

" Sets python tabs to space in accord to PEP8
autocmd FileType python setlocal expandtab

" Opens NERDTree if no file was specified on launch
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Sets jsonc filetype
autocmd BufNewFile,BufRead *.jsonc set ft=jsonc
