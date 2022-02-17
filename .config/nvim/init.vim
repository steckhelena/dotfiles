scriptencoding utf-8

lua << END

require('plugins')
require('lsp')
require('theme')
require('settings')

END

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

autocmd BufWritePre *.lua lua vim.lsp.buf.formatting_sync(nil, 100)

" set foldmethod to use nvim treesitter
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevelstart=20

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
