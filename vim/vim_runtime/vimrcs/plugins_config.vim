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
" Define the map leader as early in the configuration as possible.
" With a map leader it's possible to do extra key combinations
let mapleader = " "
let g:mapleader = " "

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
let g:NERDTreeWinPos = "left"
let NERDTreeShowHidden=0
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let g:NERDTreeWinSize=35
map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark
map <leader>nf :NERDTreeFind<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => lightline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:lightline = {
            \ 'colorscheme': 'PaperColor',
            \ }

let g:lightline = {
            \ 'colorscheme': 'PaperColor',
            \ 'active': {
            \   'left': [ ['mode', 'paste'],
            \             ['readonly', 'filename', 'modified', 'gitstatus'] ],
            \   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'] ]
            \ },
            \ 'component': {
            \   'readonly': '%{&filetype=="help"?"":&readonly?"🔒":""}',
            \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
            \   'gitstatus': '%{exists("*FugitiveHead()")?FugitiveHead():""}'
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
            \   'gitstatus': '(exists("*FugitiveHead()") && ""!=FugitiveHead())'
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
" => tmux.nvim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vim-TMUX
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => gitgutter
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => fugitive
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => gitsigns.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap [c :Gitsigns prev_hunk<cr>
nmap ]c :Gitsigns next_hunk<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Telescope
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fc <cmd>lua require('telescope.builtin').git_commits()<cr>
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>fv <cmd>lua require('telescope.builtin').builtin.treesitter()<cr>
