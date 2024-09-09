autocmd BufNewFile,BufRead *.rules set filetype=firestore

" Use '//' as comment character
autocmd FileType firestore setlocal commentstring=\/\/\ %s
