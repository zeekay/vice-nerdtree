call vice#CreateCommand('NERDTreeCD', ['github:scrooloose/nerdtree'], {
    \ 'after': 'vice#nerdtree#after'
\ })

call vice#CreateCommand('NERDTreeToggle', ['github:scrooloose/nerdtree'], {
    \ 'after': 'vice#nerdtree#after'
\ })

call vice#CreateCommand('FileExplorer', ['github:scrooloose/nerdtree'], {
    \ 'after': 'vice#nerdtree#after'
\ })

" Auto open nerd tree on startup
let g:nerdtree_tabs_open_on_gui_startup = 0

" Focus in the main content window
let g:nerdtree_tabs_focus_on_files = 1

" Make nerdtree look nice
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1
let g:NERDTreeWinSize = 30
let g:NERDTreeMouseMode = 3
let g:NERDTreeCaseSensitiveSort = 1
let g:NERDTreeChDirMode = 2

" Default key: C/cd
let g:NERDTreeMapChdir = 'C'

" Default key: CD
let g:NERDTreeMapCWD = 'cd'

nnoremap <leader>n :NERDTreeToggle<cr>
nnoremap <leader>N :NERDTreeCD<cr>

augroup NERDTreeHijackNetrw
    autocmd VimEnter * silent! autocmd! FileExplorer
    au BufEnter,VimEnter * silent! call vice#nerdtree#check_for_browse(expand("<amatch>"))
augroup END
