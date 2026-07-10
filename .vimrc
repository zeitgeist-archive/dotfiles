set nocompatible
syntax on
filetype plugin indent on
set termguicolors

call plug#begin('~/.vim/plugged')
  Plug 'morhetz/gruvbox'
  Plug 'catppuccin/vim', {'as': 'catppuccin'}
  Plug 'folke/tokyonight.nvim'
  Plug 'arcticicestudio/nord-vim'
  Plug 'dracula/vim', {'as': 'dracula'}
  Plug 'sainnhe/everforest'
  Plug 'lifepillar/vim-solarized8'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'ryanoasis/vim-devicons'
  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'
call plug#end()

" Essential settings
set encoding=utf-8
set number
set relativenumber
set cursorline
set updatetime=250 " Force GitGutter/Airline to update changes almost instantly (250ms)
set shortmess+=S   " Hide the default Vim search count below the airline bar

" Theme rotation
let g:my_colorschemes = ['gruvbox', 'catppuccin', 'tokyonight', 'nord', 'dracula', 'everforest', 'solarized8']
let g:my_index = 0

function! CycleColors()
    let g:my_index = (g:my_index + 1) % len(g:my_colorschemes)
    let l:new_scheme = g:my_colorschemes[g:my_index]
    
    if l:new_scheme == 'tokyonight' && !has('nvim')
        let g:my_index = (g:my_index + 1) % len(g:my_colorschemes)
        let l:new_scheme = g:my_colorschemes[g:my_index]
    endif
    
    execute 'colorscheme ' . l:new_scheme
    call writefile([l:new_scheme], expand('~/.vim/current_theme'))
    echo "Theme: " . l:new_scheme
endfunction
nnoremap <C-l> :call CycleColors()<CR>

autocmd SourcePost ~/.vimrc if filereadable(expand('~/.vim/current_theme')) 
    \ | execute 'colorscheme ' . readfile(expand('~/.vim/current_theme'))[0] 
    \ | else | colorscheme gruvbox | endif

" --- STRICT AIRLINE CONFIGURATION ---
" Ensure vibrant colors match the theme dynamically
" By omitting the static g:airline_theme, it falls back to 'auto' 
" which loads the specific high-contrast map for the current active colorscheme.
" Removing the forced gruvbox theme ensures insert/normal modes are colorful.
unlet! g:airline_theme
let g:airline_powerline_fonts = 1

" Explicitly enable extensions FIRST
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#hunks#non_zero_only = 0
let g:airline#extensions#hunks#gitgutter = 1
let g:airline#extensions#searchcount#enabled = 1
let g:airline#extensions#searchcount#show_search_term = 1

function! AirlineInit()
  " Kill UTF and Fileformat internally
  let g:airline#parts#ff = ''
  let g:airline#parts#fileencoding = ''
  let g:airline#parts#encoding = ''
  
  " Map EXACTLY the requested information
  let g:airline_section_a = airline#section#create_left(['mode', 'crypt', 'spell', 'paste'])
  let g:airline_section_b = airline#section#create_left(['branch', 'hunks'])
  let g:airline_section_c = airline#section#create_left(['%t'])

  " Combine Line:Col and Search into X, Wordcount in Y (was blank), Filetype/Theme in Z
  let g:airline_section_x = airline#section#create_right(['%l:%c', '%{airline#extensions#searchcount#status()}'])
  let g:airline_section_y = airline#section#create_right(['wordcount'])
  " Z: Filetype and current active theme
  let g:airline_section_z = airline#section#create_right(['filetype', ' %{exists("g:colors_name") ? g:colors_name : ""}'])
endfunction
autocmd User AirlineAfterInit call AirlineInit()

" Include 'y' back in the layout now that it holds wordcount instead of UTF
let g:airline#extensions#default#layout = [
  \ [ 'a', 'b', 'c' ],
  \ [ 'x', 'y', 'z' ]
  \ ]

" Force disable the specific extensions that generate the UTF info
let g:airline#extensions#wordcount#enabled = 1
let g:airline#extensions#whitespace#enabled = 0
let g:airline_section_warning = ''
let g:airline_section_error = ''
" ------------------------------------

for s:path in split(glob('~/.vim/plugged/*'), '\n')
    if isdirectory(s:path . '/colors')
        execute 'set runtimepath+=' . s:path
    endif
endfor
