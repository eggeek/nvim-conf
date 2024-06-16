let g:maplocalleader = ' '
let g:vimtex_view_method = 'zathura'

let g:vimtex_log_ignore = [
        \ 'Underfull',
        \ 'Overfull',
        \ 'specifier changed to',
        \ 'Token not allowed in a PDF string',
      \ ]
let g:vimtex_compiler_latexmk = {
        \ 'callback' : 1,
        \ 'continuous' : 1,
        \ 'executable' : 'latexmk',
        \ 'hooks' : [],
        \ 'options' : [
        \   '-shell-escape',
        \   '-verbose',
        \   '-file-line-error',
        \   '-synctex=1',
        \   '-interaction=nonstopmode',
        \ ],
        \}

let g:vimtex_grammar_vlty = {'lt_command': 'languagetool'}

let g:vimtex_complete_enabled = 0
let g:tex_comment_nospell = 1
let g:vimtex_matchparen_enabled = 0
let g:matchup_override_vimtex = 0
let g:matchup_matchparen_deferred = 1
let g:vimtex_quickfix_open_on_warning = 0

nmap <localleader>wc :VimtexCountWords<CR>
nmap <localleader>lv :VimtexView<CR>
xmap <localleader>wc :VimtexCountWords<CR>

