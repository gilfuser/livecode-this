set runtimepath^=~/.vim runtimepath+=~/.vim/after

let &packpath = &runtimepath
"source ~/.vimrc
set relativenumber
call plug#begin('~/.local/share/nvim/plugged')
"Plug 'tpope/vim-sensible'
Plug 'tpope/vim-fugitive'
"Plug 'gilfuser/vim-tidal', {'pinned' : 1}
Plug 'tidalcycles/vim-tidal'
Plug 'Raimondi/delimitMate'
" Plug 'supercollider/scvim'
Plug 'zhou13/vim-easyescape'
Plug 'gilfuser/ultisnips'
"Plug 'gilfuser/vim-snippets'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"Plug 'neitanod/vim-clevertab'
Plug 'tpope/vim-surround'
Plug 'easymotion/vim-easymotion'
"Plug 'powerline/powerline'
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
"Plug 'tpope/vim-vinegar'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdtree-project-plugin'
Plug 'w0rp/ale'
"Plug 'joshdick/onedark.vim'
Plug 'morhetz/gruvbox'
"Plug 'whatyouhide/vim-gotham'
"Plug 'nanotech/jellybeans.vim'
"Plug 'jacoborus/tender.vim'
Plug '~/.dotfiles/plugged/scvim'
Plug 'vim-syntastic/syntastic'
Plug 'kassio/neoterm'
Plug 'scrooloose/nerdcommenter'
Plug 'dkprice/vim-easygrep'
Plug 'sheerun/vim-polyglot'
"Plug 'edkolev/tmuxline.vim'
" Plug 'https://github.com/lervag/vimtex'
Plug 'posva/vim-vue'
Plug 'Yggdroot/indentLine'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'davidgranstrom/scnvim'
call plug#end()

" for polyglot
syntax on

" FOR COLOR THEME
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (has("termguicolors"))
 set termguicolors
endif
"let g:onedark_termcolors = 256
"let g:lightline = {
"  \ 'colorscheme': 'onedark',
"  \ }

set mouse=a

" Colors Themes and Whatnots
syntax on
"colorscheme onedark
"colorscheme gotham
colorscheme gruvbox
set background=dark
let g:gruvbox_contrast_dark='hard'

"let g:airline_theme='onedark'
let g:airline_theme='gruvbox'
"let g:airline#extensions#tabline#enabled = 1
" from .vimrc. TO DO: Bring everything here
" change background color when in insert mode
augroup mode_change_bkground
    autocmd!
    au InsertEnter * hi Normal ctermbg=234 guibg=#000000
    au InsertLeave * hi Normal ctermbg=232 guibg=#1b1d1e
augroup END

" DelimitMate
let delimitMate_matchpairs = "(:),[:],{:},<:>"
let delimitMate_quotes = "\" ` "
let delimitMate_expand_space = 1
let g:deoplete#enable_at_startup = 1

"UltiSnips
let g:UltiSnipsUsePythonVersion = 3
inoremap <c-x><c-k> <c-x><c-k>
" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <expr><TAB>
smap <expr><TAB>
\ pumvisible() ? "\<C-n>" :
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

let maplocalleader= "ä"
let mapleader = "ö"

" Neoterm stuff
let g:neoterm_size = 10
let g:neoterm_autoscroll = 1
let g:neoterm_autojump = 1
" hide/close terminal
nnoremap <silent> ,th :call neoterm#close()<cr>
" clear terminal
nnoremap <silent> ,tl :call neoterm#clear()<cr>
" kills the current job (send a <c-c>)
nnoremap <silent> ,tc :call neoterm#kill()<cr>

" SCVIM SuperCollider!
let g:scFlash = 1
let g:sclangTerm = "terminator -x $SHELL -ic"
let g:sclangPipeApp = "~/.dotfiles/plugged/scvim/bin/start_pipe"
let g:sclangDispatcher = "~/.dotfiles/plugged/scvim/bin/sc_dispatcher"
let g:scSplitDirection = "v"
let g:scSplitSize = 33
"nnoremap <leader>e :call SClang_line()<CR>
"inoremap <leader>e <ESC>:call SClang_line()<CR>i
"vnoremap <leader>e :call SClang_line()<CR>
"nnoremap <leader>w :call SClang_block()<CR>
"vnoremap <leader>w :call SClang_block()<CR>
"inoremap <leader>w <ESC>:call SClang_block()<CR>i
"noremap <leader>b :SClangStart <CR>
"augroup filetype_supercollider
"    autocmd!
"    autocmd FileType supercollider nnoremap <buffer> <localleader>7 I// <esc>
"    autocmd BufNewFile,BufRead *.scd :T ~/.dotfiles/plugged/scvim/bin/start_pipe 
"augroup END


" FOR TIDAL-VIM """""""""""""""""""""""""""""""""""""""""""""""""""
" disable tidalvim default mapping:
" let g:tidal_no_mappings = 1

"augroup filetype_tidal
"    autocmd!
"    autocmd BufNewFile,BufRead *.tidal :Tnew
"    autocmd BufReadPost *.tidal :TREPLSetTerm 2 | :T2 tidal
"augroup END

" see tmux target on github vim-tidal README

""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Change Color when entering Insert Mode
"autocmd InsertEnter * highlight  CursorLine ctermbg=DarkBlue
" Revert Color to default when leaving Insert Mode
"autocmd InsertLeave * highlight  CursorLine ctermbg=DarkGray
" replace tab with spaces
set tabstop=4 shiftwidth=4 expandtab

" NERDTree stuff
" enable NERDTree line numbers
let NERDTreeShowLineNumbers=1
let g:NERDTreeShowHidden=1
" make sure relative line numbers are used
autocmd FileType nerdtree setlocal relativenumber
" toggle NERDTree
noremap <Leader>n :NERDTreeToggle<cr>
" open NERDTree at startup
"autocmd VimEnter * NERDTree
"autocmd VimEnter * wincmd p
" open new split panes right and bottom
set splitbelow
set splitright

" easyMotion
"nnoremap <leader>q <leader><leader>
let g:EasyMotion_do_mapping=1

" terminal mode stuff
tnoremap <leader><Esc> <c-\><c-n>
highlight TermCursor ctermfg=red guifg=red"
"au BufEnter * if &buftype == 'terminal' | :startinsert | endif

"""""" My Own Stuff """""""

" easyest moving between tabs
" Terminal mode:
tnoremap <A-h> <c-\><c-n>gT
tnoremap <A-l> <c-\><c-n>gt
" Insert mode:
inoremap <A-h> <Esc>gT
inoremap <A-l> <Esc>gt
" Visual mode:
vnoremap <A-h> <Esc>gT
vnoremap <A-l> <Esc>gt
" Normal mode:
nnoremap <A-h> gT
nnoremap <A-l> gt

" easyest moving between splits
" Terminal mode:
"tnoremap <A-h> <c-\><c-n><c-w>h
"tnoremap <A-j> <c-\><c-n><c-w>j
"tnoremap <A-k> <c-\><c-n><c-w>k
"tnoremap <A-l> <c-\><c-n><c-w>l
" Insert mode:
"inoremap <A-h> <Esc><c-w>h
"inoremap <A-j> <Esc><c-w>j
"inoremap <A-k> <Esc><c-w>k
"inoremap <A-l> <Esc><c-w>l
" Visual mode:
"vnoremap <A-h> <Esc><c-w>h
"vnoremap <A-j> <Esc><c-w>j
"vnoremap <A-k> <Esc><c-w>k
"vnoremap <A-l> <Esc><c-w>l
" Normal mode:
"nnoremap <A-h> <c-w>h
"nnoremap <A-j> <c-w>j
"nnoremap <A-k> <c-w>k
"nnoremap <A-l> <c-w>l

" move line
nnoremap <leader><A-j> :m .+1<CR>==
nnoremap <leader><A-k> :m .-2<CR>==
inoremap <leader><A-j> <Esc>:m .+1<CR>==gi
inoremap <leader><A-k> <Esc>:m .-2<CR>==gi
vnoremap <leader><A-j> :m '>+1<CR>gv=gv
vnoremap <leader><A-k> :m '<-2<CR>gv=gv

" substitute a little bit faster
nnoremap <leader>7 <Esc>:%s/
inoremap <leader>7 <Esc>:%s/
vnoremap <leader>7 <Esc>:%s/
" linewise:
nnoremap <leader>8 <Esc>:s/
inoremap <leader>8 <Esc>:s/
vnoremap <leader>8 <Esc>:s/

" Select word faster
nnoremap <leader>w viw
inoremap <leader>w <Esc> iw
vnoremap <leader>w iw
nnoremap <localleader>w viW
inoremap <localleader>w <Esc> viW
vnoremap <localleader>w iW
"... and change
nnoremap <leader>q ciw
inoremap <leader>q <Esc> ciw
vnoremap <leader>q iwc
nnoremap <localleader>q ciW
inoremap <localleader>q <Esc> ciW
vnoremap <localleader>q iWc

" to select in between "" [] <> {} ()
nnoremap <leader><A-2> vi"
inoremap <leader><A-2> <Esc>vi"c
nnoremap <localleader><A-2> va"
inoremap <localleader><A-W> <Esc>va"c
nnoremap <leader><A-7> vi}
inoremap <leader><A-7> <Esc>vi}c
nnoremap <localleader><A-7> va}
inoremap <localleader><A-7> <Esc>va}c
nnoremap <leader><A-8> vi]
inoremap <leader><A-8> <Esc>vi]c
nnoremap <localleader><A-8> va]
inoremap <localleader><A-8> <Esc>va]c
nnoremap <leader><A-9> vi)
inoremap <leader><A-9> <Esc>vi)c
nnoremap <localleader><A-9> va)
inoremap <localleader><A-9> <Esc>va)c
nnoremap <leader><A-y> vi>
inoremap <leader><A-y> <Esc>vi>c
nnoremap <localleader><A-y> va>
inoremap <localleader><A-y> <Esc>va>c

" select whole line from last to first non-empty char
inoremap <leader>l <Esc>g_v^
nnoremap <leader>l g_v^
vnoremap <leader>l <Esc>g_v^

" Create line witout leaving mode
inoremap <localleader>o <Esc>o<Esc>ki
inoremap <localleader>O <Esc>O<Esc>ji
nnoremap <localleader>o o<Esc>k
nnoremap <localleader>O O<Esc>j

" tidal snippets: 
" make 'do' and 'once' at once
inoremap <leader>d <ESC>{O<ESC>jido<ESC>}o<ESC>kionce $<ESC>A 
vnoremap <leader>d <ESC>{O<ESC>jido<ESC>}o<ESC>kionce $<ESC>v
nnoremap <leader>d {O<ESC>jido<ESC>}o<ESC>kionce $<ESC>g_
" comment it
inoremap <leader>D <ESC>{j^i--<ESC>}k^i-- $<ESC>A 
vnoremap <leader>D <ESC>{j^i--<ESC>}k^i-- $<ESC>v
nnoremap <leader>D {j^i--<ESC>}k^i-- $<ESC>g_

" comment selection
" nnoremap <localleader><A-c> S \^] F{a- <ESC>f}i -<ESC>
" uncoment
" nnoremap <localleader><A-C> F{vlldf}vhhd

" go back to last edit
nnoremap <A-#> `. :noh<CR>
nnoremap <A-'> '" :noh<CR>

" turn search highlight off
nnoremap <leader><A-n> :noh<CR>
inoremap <leader><A-n> <ESC>:noh<CR>i
vnoremap <leader><A-n> :noh<CR>

" go to mark and put it the middle of screen
nnoremap 'a `a zt
nnoremap 'b `b zt
nnoremap 'c `c zt
nnoremap 'd `d zt
nnoremap 'e `e zt
nnoremap 'f `f zt
nnoremap 'g `g zt
nnoremap 'h `h zt
nnoremap 'i `i zt
nnoremap 'j `j zt
nnoremap 'k `k zt
nnoremap 'l `l zt
nnoremap 'm `m zt
nnoremap 'n `n zt
nnoremap 'o `o zt
nnoremap 'p `p zt
nnoremap 'q `q zt
nnoremap 'r `r zt
nnoremap 's `s zt
nnoremap 'w `w zt
nnoremap 't `t zt
nnoremap 'u `u zt
nnoremap 'v `v zt
nnoremap 'x `x zt
nnoremap 'y `y zt
nnoremap 'z `z zt

inoremap 'a <ESC>`a zti
inoremap 'b <ESC>`b zti
inoremap 'c <ESC>`c zti
inoremap 'd <ESC>`d zti
inoremap 'e <ESC>`e zti
inoremap 'f <ESC>`f zti
inoremap 'g <ESC>`g zti
inoremap 'h <ESC>`h zti
inoremap 'i <ESC>`i zti
inoremap 'j <ESC>`j zti
inoremap 'k <ESC>`k zti
inoremap 'l <ESC>`l zti
inoremap 'm <ESC>`m zti
inoremap 'n <ESC>`n zti
inoremap 'o <ESC>`o zti
inoremap 'p <ESC>`p zti
inoremap 'q <ESC>`q zti
inoremap 'r <ESC>`r zti
inoremap 's <ESC>`s zti
inoremap 'w <ESC>`w zti
inoremap 't <ESC>`t zti
inoremap 'u <ESC>`u zti
inoremap 'v <ESC>`v zti
inoremap 'x <ESC>`x zti
inoremap 'y <ESC>`y zti
inoremap 'z <ESC>`z zti

"""""""""""""""""""""""""""""""""""""""""""""""

" NERDCommenter
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Set a language to use its alternate delimiters by default
" let g:NERDAltDelims_java = 1
" Add your own custom formats or override the defaults	
let NERDAltDelims_haskell = 1
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
let g:NERDCustomDelimiters = { 'hs': { 'left': '\{-','right': '-\}' } }
let g:NERDCustomDelimiters = { 'tidal': { 'left': '{-','right': '-}' } }
let g:NERDCustomDelimiters = { 'tidal': { 'left': '--','right': '' } }
" let g:NERDCustomDelimiters = { 'hs': { 'left': '\{- ','right': ' -\}' } }
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

let g:vimtex_compiler_progname = 'nvr'
" let g:polyglot_disabled = ['latex']

" ESLINT
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exe = 'npm run lint --'

" number toggle
set number relativenumber

