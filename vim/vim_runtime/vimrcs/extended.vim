"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File name: extended.vim
"
" File description: Extended settings
"
"
" Maintainer:
"       Sergio Ruiz
"       https://sejoruiz.github.io - sejoruiz@gmail.com
"
" Version:
"       1.0 - 17/05/2024 "
"
" Sections:
"    -> GUI Related
"    -> Fast editing and reloading of vimrc configs
"    -> Turn persistent undo on
"    -> Command mode related
"    -> Parenthesis/bracket
"    -> General abbreviations
"    -> Omni complete functions
"    -> Helper functions
"
"
" Acknowledgements: https://github.com/amix/vimrc
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

set background=light
set cursorline

" Force 24-bit RGB color in TUI. For some reason, nvim does not detect this
" correctly when running over SSH on a TMUX session
set termguicolors

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

try
    " Nord specific vars. Unused, but may want to come back to Nord theme
    let g:nord_italic = 1
    let g:nord_italic_comments = 1
    let g:nord_underline = 1
    let g:nord_uniform_status_lines = 1
    let g:nord_cursor_line_number_background = 1

    " Set light background and theme
    set background=light
    colorscheme PaperColor
catch
endtry

" Highlight trailing tabs and spaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Options for VIM in GUI mode
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set font
set gfn=Iosevka\ Term\ 12,Inconsolata\ 13,DejaVu\ Sans\ Mono\ 11,Bitstream\ Vera\ Sans\ Mono\ 11,PowerlineSymbols\ 12

" Disable scrollbars in GUI mode
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Turn persistent undo on
"    means that you can undo even when you close a buffer/VIM
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
try
    set undodir=~/.tmp/vim/undodir
    set undofile
catch
endtry
