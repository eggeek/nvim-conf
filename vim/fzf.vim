augroup InitFZF
  au FileType fzf 
        \ imap <buffer> <c-n> <down>
        \ imap <buffer> <c-p> <up>
augroup end
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.6, 'highlight': 'Todo'} }

function! FzfSpellSink(word)
  exe 'normal! "_ciw'.a:word
endfunction

function! FzfSpell()
  let suggestions = spellsuggest(expand("<cword>"))
  return fzf#run({'source': suggestions, 'sink': function("FzfSpellSink"), 'down': 10 })
endfunction

nnoremap z= :call FzfSpell()<CR>

function! s:bibtex_cite_sink(lines)
  let r=system('bibtex-cite -prefix="\cite{" -postfix="}" -separator=","', a:lines)
    execute ':normal! a' . r
endfunction

function! s:bibtex_markdown_sink(lines)
    let r=system("bibtex-markdown ", a:lines)
    execute ':normal! a' . r
endfunction

function! s:bibtex_cite_sink_insert(lines)
    let r=system('bibtex-cite -prefix="" -separator="," ', a:lines)
    execute ':normal! i' . r
    call feedkeys('a', 'n')
endfunction

function! Bibtex_ls()
  let bibfiles = (
      \ globpath('.', '*.bib', v:true, v:true) +
      \ globpath('..', '*.bib', v:true, v:true) +
      \ globpath('*/', '*.bib', v:true, v:true)
      \ )
  let bibfiles = join(bibfiles, ' ')
  let source_cmd = 'bibtex-ls '.bibfiles
  return source_cmd
endfunction

nnoremap <silent> <leader>ff :call fzf#run({
      \ 'source': 'fd -I --type f .',
      \ 'sink': 'e',
      \ 'window': g:fzf_layout['window'],
      \ 'options': '--prompt "All Files> "'
      \})<CR>

nnoremap <silent> <leader>ct :call fzf#run({
                        \ 'source': Bibtex_ls(),
                        \ 'sink*': function('<sid>bibtex_cite_sink'),
                        \ 'down': '20%',
                        \ 'options': '--ansi --layout=reverse-list --multi --prompt "Cite> "'})<CR>

nnoremap <silent> <leader>md :call fzf#run({
                        \ 'source': Bibtex_ls(),
                        \ 'sink*': function('<sid>bibtex_markdown_sink'),
                        \ 'window': g:fzf_layout['window'],
                        \ 'options': '--ansi --layout=reverse-list --multi --prompt "Markdown> "'})<CR>

au FileType tex inoremap <buffer><silent> @@ <c-g>u<c-o>:call fzf#run({
                        \ 'source': Bibtex_ls(),
                        \ 'sink*': function('<sid>bibtex_cite_sink_insert'),
                        \ 'window': g:fzf_layout['window'],
                        \ 'options': '--ansi --layout=reverse-list --multi --prompt "Cite> "'})<CR>
