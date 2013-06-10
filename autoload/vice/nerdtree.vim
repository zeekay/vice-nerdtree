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
    silent! NERDTree ..
    pwd
endf

" callback after nerdtree is loaded
func! vice#nerdtree#after()
    call g:NERDTreeKeyMap.Create({
        \ 'key': 'C',
        \ 'callback': 'vice#nerdtree#cd_callback',
        \ 'quickhelpText': 'echo full path of current node',
        \ 'scope': 'DirNode',
    \ })

    call g:NERDTreeKeyMap.Create({
       \ 'key': 'u',
       \ 'callback': 'vice#nerdtree#up_callback',
       \ 'quickhelpText': 'echo full path of current node',
       \ 'scope': 'all',
    \ })

    command! -nargs=0 NERDTreeCD call vice#nerdtree#cd()
endf

function! vice#nerdtree#check_for_browse(dir)
    if a:dir != '' && isdirectory(a:dir)
        call vice#ForceActivateAddon('github:scrooloose/nerdtree')
        call g:NERDTreeCreator.CreateSecondary(a:dir)
    endif
endfunction
