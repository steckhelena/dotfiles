local cmd = vim.cmd

-- When editing a file, always jump to the last known cursor position.
-- Don't do it when the position is invalid, when inside an event handler
-- (happens when dropping a file on gvim) and for a commit message (it's
-- likely a different one than last time).
cmd [[augroup vimStartup]]
cmd [[au!]]
cmd [[
    autocmd BufReadPost *
        \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
        \ |   exe "normal! g`\""
        \ | endif
]]
cmd [[augroup END]]

-- use tabs on Makefiles
cmd [[autocmd FileType make set noexpandtab]]

-- Sets rasi as a css file
cmd [[autocmd BufNewFile,BufRead *.rasi set syntax=css]]

-- Sets python tabs to space in accord to PEP8
cmd [[autocmd FileType python setlocal expandtab]]

-- Sets jsonc filetype
cmd [[autocmd BufNewFile,BufRead *.jsonc set ft=jsonc]]
