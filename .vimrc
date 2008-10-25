set clipboard=unnamed
:nnoremap <expr> p (v:register == '"' && &clipboard =~ 'unnamed' ? '"*p' : '"' . v:register . 'p')

highlight Pmenu ctermfg=2 ctermbg=1 
highlight PmenuSel ctermbg=Brown ctermfg=Magenta
