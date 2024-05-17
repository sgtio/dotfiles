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
" => GUI related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set font according to system
if has("mac") || has("macunix")
    set gfn=Hack:h14,Source\ Code\ Pro:h15,Menlo:h15
elseif has("win16") || has("win32")
    set gfn=Hack:h14,Source\ Code\ Pro:h12,Bitstream\ Vera\ Sans\ Mono:h11
elseif has("gui_gtk3")
    set gfn=Iosevka\ Term\ 12,Inconsolata\ 13,DejaVu\ Sans\ Mono\ 11,Bitstream\ Vera\ Sans\ Mono\ 11,PowerlineSymbols\ 12
elseif has("linux")
    set gfn=Iosevka\ Term\ 12,Inconsolata\ 13,DejaVu\ Sans\ Mono\ 11,Bitstream\ Vera\ Sans\ Mono\ 11,PowerlineSymbols\ 12
elseif has("unix")
    set gfn=Monospace\ 12
endif

" Open MacVim in fullscreen mode
if has("gui_macvim")
    set fuoptions=maxvert,maxhorz
    au GUIEnter * set fullscreen
endif

" Disable scrollbars
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L

" Colorscheme
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors

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
" => Turn persistent undo on
"    means that you can undo even when you close a buffer/VIM
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
try
    set undodir=~/.tmp/vim/undodir
    set undofile
catch
endtry
