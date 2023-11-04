"----------------------------------------------------------------------
" EMACS style keybinding in INSERT
"----------------------------------------------------------------------
" inoremap <c-p> <up>
" inoremap <c-n> <down>
" inoremap <c-k> <c-o>d$
" inoremap <C-A> <C-O>^
" inoremap <expr> <C-B> getline('.')=~'^\s*$'&&col('.')>strlen(getline('.'))<bar><bar>pumvisible()?"0\<Lt>C-D>\<Lt>Esc>kJs":"\<Lt>Left>"
" inoremap <expr> <C-D> col('.')>strlen(getline('.'))<bar><bar>pumvisible()?"\<Lt>C-D>":"\<Lt>Del>"
" inoremap <expr> <C-E> col('.')>strlen(getline('.'))<bar><bar>pumvisible()?"\<Lt>C-E>":"\<Lt>End>"
" inoremap <expr> <C-F> col('.')>strlen(getline('.'))<bar><bar>pumvisible()?"\<Lt>C-F>":"\<Lt>Right>"
"----------------------------------------------------------------------
" EMACS style keybinding in COMMAND
"----------------------------------------------------------------------
set cedit = ""
cnoremap        <C-A> <Home>
cnoremap   <C-X><C-A> <C-A>
cnoremap        <C-B> <Left>
cnoremap <expr> <C-D> getcmdpos()>strlen(getcmdline())?"\<Lt>C-D>":"\<Lt>Del>"
cnoremap <expr> <C-F> getcmdpos()>strlen(getcmdline())?"":"\<Lt>Right>"
cnoremap <C-k> <C-\>estrpart(getcmdline(),0,getcmdpos()-1)<CR>
cnoremap <M-d> <S-Right><C-W>
