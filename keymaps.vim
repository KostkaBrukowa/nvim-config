" Set leader keys
let g:mapleader = " "
let g:maplocalleader = " "

" Disable space in normal and visual mode
noremap <Space> <Nop>

" Better paste in visual mode
vnoremap p "_dP

" Text editing
" Faster movement to end and beginning of the line
nnoremap I $
nnoremap H ^
vnoremap I $
vnoremap H ^

" Alt-j join line below, weird coz of other remap
if has("macunix")
  nnoremap ń J
else
  nnoremap <A-n> J
endif

" Movement remapping
noremap N 9j
noremap E 9k

noremap n j
noremap e k
noremap j e
noremap J E

" Yank to end of line
nnoremap Y y$

" Change current word and allow to use . for changing next words
nnoremap c* *Ncgn

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-n> <C-w>j
nnoremap <C-e> <C-w>k
nnoremap <F13> <C-w>l
inoremap <C-h> <cmd>wincmd h<cr>
inoremap <C-n> <cmd>wincmd j<cr>
inoremap <C-e> <cmd>wincmd k<cr>

" Go back and forward
nnoremap <C-l> <C-o>
nnoremap <C-u> <C-i>

" Center after jump
nnoremap `` ``zz

" Stay in indent mode when formatting
vnoremap < <gv
vnoremap > >gv

" Switch to alternate file
nnoremap <Backspace> <C-^>

" Redo
nnoremap U <c-r>

" Alt-backspace to delete word backwards
inoremap <A-Backspace> <ESC>lcb
nnoremap <A-Backspace> lcb<ESC>

" Save all files
nnoremap <leader>w :wall<CR>

" Reopen file
nnoremap <leader>e :e<CR>

" Save and exit
nnoremap <leader>q :wall<CR>:lua vim.defer_fn(function() vim.cmd('qall') end, 100)<CR>

" Start macro
nnoremap zq q
