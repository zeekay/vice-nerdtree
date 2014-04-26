" Silently toggle Nerdtree, changing cwd to file toggle is executed from.
func! vice#nerdtree#cd()
    echo
    silent! NERDTree %:p:h
    pwd
endf

" callback for nerdtree cd
func! vice#nerdtree#cd_callback(dirnode)
    silent! exec 'NERDTree '.a:dirnode.path.str()
    pwd
endf

" callback for nerdtree up
func! vice#nerdtree#up_callback()
    if expand('%:p:h') != '/'
        silent! NERDTree ..
    endif
    pwd
endf

" callback for ~
func! vice#nerdtree#home_callback()
    silent! NERDTree $HOME
    pwd
endf

" callback after nerdtree is loaded
func! vice#nerdtree#after()
    call g:NERDTreeKeyMap.Create({
        \ 'key': 'C',
        \ 'callback': 'vice#nerdtree#cd_callback',
        \ 'quickhelpText': 'cd and echo full path of current node',
        \ 'scope': 'DirNode',
    \ })

    call g:NERDTreeKeyMap.Create({
       \ 'key': 'u',
       \ 'callback': 'vice#nerdtree#up_callback',
       \ 'quickhelpText': 'Move up and echo full path of current node',
       \ 'scope': 'all',
    \ })

    call g:NERDTreeKeyMap.Create({
       \ 'key': '-',
       \ 'callback': 'vice#nerdtree#up_callback',
       \ 'quickhelpText': 'Move up and echo full path of current node',
       \ 'scope': 'all',
    \ })

    call g:NERDTreeKeyMap.Create({
       \ 'key': '~',
       \ 'callback': 'vice#nerdtree#home_callback',
       \ 'quickhelpText': 'Navigate to $HOME',
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
endf
