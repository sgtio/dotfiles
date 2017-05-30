"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File name: plugins_config.vim
"
" File description: Plugins configuration
" 
"
" Maintainer: 
"       Sergio Ruiz
"       https://sejoruiz.github.io - sejoruiz@gmail.com
"
" Version: 
"       0.1 - 12/07/2016
"
"
" Sections:
"    -> Dein 
"    -> bufExplorer
"    -> MRU plugin
"    -> YankStack
"    -> CTRL-P
"    -> Emmet
"    -> Vim grep
"    -> Nerd Tree
"    -> vim-multiple-cursors
"    -> lightline
"    -> Goyo
"    -> Syntastic
"    -> Git gutter
"
"
" Acknowledgements: https://github.com/amix/vimrc
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""
" => Dein
""""""""""""""""""""""""""""""
if &compatible
    set nocompatible
endif
set runtimepath+=~/.vim_runtime/bundle/repos/github.com/Shougo/dein.vim

call dein#begin(expand('~/.vim_runtime/bundle'))

" Let dein manage dein
" Required:
call dein#add('Shougo/dein.vim')

" Begin list of plugins:
call dein#add('altercation/vim-colors-solarized.git')
call dein#add('jlanzarotta/bufexplorer')
call dein#add('scrooloose/nerdtree')
call dein#add('terryma/vim-multiple-cursors')
call dein#add('itchyny/lightline.vim')
call dein#add('mileszs/ack.vim')
call dein#add('christoomey/vim-tmux-navigator')
" End list of plugins

call dein#end()

filetype plugin indent on

""""""""""""""""""""""""""""""
" => bufExplorer plugin
""""""""""""""""""""""""""""""
let g:bufExplorerDefaultHelp=0
let g:bufExplorerShowRelativePath=1
let g:bufExplorerFindActive=1
let g:bufExplorerSortBy='name'
map <leader>o :BufExplorer<cr>
nnoremap <silent> <M-F12> :BufExplorer<CR>
nnoremap <silent> <F12> :bn<CR>
nnoremap <silent> <S-F12> :bp<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Nerd Tree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:NERDTreeWinPos = "right"
let NERDTreeShowHidden=0
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let g:NERDTreeWinSize=35
map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark
map <leader>nf :NERDTreeFind<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-multiple-cursors
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:multi_cursor_next_key="\<C-s>"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => lightline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:lightline = {
            \ 'colorscheme': 'solarized',
            \ }

let g:lightline = {
            \ 'colorscheme': 'solarized',
            \ 'active': {
            \   'left': [ ['mode', 'paste'],
            \             ['fugitive', 'readonly', 'filename', 'modified'] ],
            \   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'] ]
            \ },
            \ 'component': {
            \   'readonly': '%{&filetype=="help"?"":&readonly?"🔒":""}',
            \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
            \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
            \ },
            \ 'component_expand': {
            \   'syntastic': 'SyntasticStatuslineFlag',
            \ },
            \ 'component_type': {
            \   'syntastic': 'error',
            \ },
            \ 'component_visible_condition': {
            \   'readonly': '(&filetype!="help"&& &readonly)',
            \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
            \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
            \ },
            \ 'separator': { 'left': ' ', 'right': ' ' },
            \ 'subseparator': { 'left': ' ', 'right': ' ' }
            \ }

function! s:syntastic()
    SyntasticCheck
    call lightline#update()
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Ack (replacement for vim grep)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ackprg = 'ag --vimgrep --smart-case'
cnoreabbrev ag Ack!
cnoreabbrev aG Ack!
cnoreabbrev Ag Ack!
cnoreabbrev AG Ack!

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vim-TMUX
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
