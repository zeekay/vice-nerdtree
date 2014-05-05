" Silently toggle Nerdtree, changing cwd to file toggle is executed from.
func! vice#nerdtree#cd()
    echo
    silent! NERDTree %:p:h
    pwd
endf

func! vice#nerdtree#cd_node(node)
    silent! exe 'keepjumps cd '.a:node.path.str()
    pwd
endf

func! vice#nerdtree#cl_node(node)
    silent! exe 'keepjumps lcd '.a:node.path.str()
    pwd
endf

" callback for nerdtree cd
func! vice#nerdtree#cd_dirnode(dirnode)
    silent! exe 'NERDTree '.a:dirnode.path.str()
    pwd
endf

" callback for nerdtree up
func! vice#nerdtree#cd_up()
    if expand('%:p:h') != '/'
        let dir = expand('%:p:h:h')
        silent! exe 'edit '.dir
        silent! exe 'cd '.dir
    endif
    pwd
endf

" callback for ~
func! vice#nerdtree#cd_home()
    silent! edit $HOME
    pwd
endf

" callback after nerdtree is loaded
func! vice#nerdtree#after()
    call g:NERDTreeKeyMap.Create({
        \ 'key': 'cd',
        \ 'callback': 'vice#nerdtree#cd_node',
        \ 'quickhelpText': 'cd to node and echo full path of current node',
        \ 'scope': 'Node',
    \ })

    call g:NERDTreeKeyMap.Create({
        \ 'key': 'cl',
        \ 'callback': 'vice#nerdtree#cl_node',
        \ 'quickhelpText': 'lcd to node and echo full path of current node',
        \ 'scope': 'Node',
    \ })

    call g:NERDTreeKeyMap.Create({
       \ 'key': 'u',
       \ 'callback': 'vice#nerdtree#cd_up',
       \ 'quickhelpText': 'cd up and echo full path of current node',
       \ 'scope': 'all',
    \ })

    command! -nargs=0 NERDTreeCD call vice#nerdtree#cd()
endf

func! vice#nerdtree#check_for_browse(dir)
    if a:dir != '' && isdirectory(a:dir)
        call vice#ForceActivateAddon('github:scrooloose/nerdtree')
        call g:NERDTreeCreator.CreateSecondary(a:dir)
    endif
endf

" Borrowed from vim-vinegar
function! s:escaped(first, last) abort
    let files = getline(a:first, a:last)
    call filter(files, 'v:val !~# "^\" "')
    call map(files, 'substitute(v:val, "[/*|@=]\\=\\%(\\t.*\\)\\=$", "", "")')

    " Strip any whitespace
    call map(files, 'substitute(v:val, "^\\s*\\(.\\{-}\\)\\s*$", "\\1", "")')
    let curdir = b:NERDTreeRoot.path.str()
    return join(map(files, 'fnamemodify(curdir."/".v:val,":~:.")'), ' ')
endf

func! vice#nerdtree#setup_mapping()
    nnoremap <buffer> . :<C-U> <C-R>=<SID>escaped(line('.'), line('.') - 1 + v:count1)<CR><Home>
    xnoremap <buffer> . <Esc>: <C-R>=<SID>escaped(line("'<"), line("'>"))<CR><Home>
    nmap <buffer> ! .!
    xmap <buffer> ! .!
    nnoremap <buffer> - :call vice#nerdtree#close_fullscreen()<cr>
    nnoremap <buffer> ~ :call vice#nerdtree#cd_home()<cr>
endf

func! vice#nerdtree#enter_fullscreen()
    let g:file_before_nerdtree = expand('%:p')
    edit .
endf

func! vice#nerdtree#close_fullscreen()
    if exists('g:file_before_nerdtree')
        exe "edit ".g:file_before_nerdtree
        unlet g:file_before_nerdtree
    endif
endf
