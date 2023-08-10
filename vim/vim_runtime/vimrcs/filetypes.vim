"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File name: filetypes.vim
"
" File description: File type specific settings
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
"    -> Python
"    -> Bitbake
"    -> Javascript
"    -> Git
"
"
" Acknowledgements: https://github.com/amix/vimrc
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" => Python section
""""""""""""""""""""""""""""""
let python_highlight_all = 1
au FileType python syn keyword pythonDecorator True None False self

au BufNewFile,BufRead *.jinja set syntax=htmljinja
au BufNewFile,BufRead *.mako set ft=mako

au FileType python map <buffer> F :set foldmethod=indent<cr>

au FileType python map <buffer> <leader>1 /class
au FileType python map <buffer> <leader>2 /def
au FileType python map <buffer> <leader>C ?class
au FileType python map <buffer> <leader>D ?def
au FileType python set textwidth=131
au FileType python set expandtab
au FileType python set shiftwidth=4
au FileType python set tabstop=4
au FileType python set softtabstop=0


"""""""""""""""""""""""""""""""
" => Bitbake section
""""""""""""""""""""""""""""""
au BufNewFile,BufRead *.bb set filetype=bitbake
au BufNewFile,BufRead *.bbappend set filetype=bitbake
au FileType bitbake set textwidth=131
au FileType python set noexpandtab
au FileType python set shiftwidth=4
au FileType python set tabstop=4
au FileType python set softtabstop=0

""""""""""""""""""""""""""""""
" => JavaScript section
"""""""""""""""""""""""""""""""
au FileType javascript setl fen
au FileType javascript setl nocindent


""""""""""""""""""""""""""""""
" => Git commit section
"""""""""""""""""""""""""""""""
au FileType gitcommit call setpos('.', [0, 1, 1, 0])
au FileType gitcommit set tw=72
