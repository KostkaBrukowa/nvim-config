" Set vim options
set whichwrap+=<,>,[,],h,l
set iskeyword+=-
set fillchars+=diff:╱
set fillchars+=fold:•
set fillchars+=vert:┃
set fillchars+=horiz:━
set fillchars+=horizup:┻
set fillchars+=horizdown:┳
set fillchars+=vertleft:┫
set fillchars+=vertright:┣
set fillchars+=verthoriz:╋
set jumpoptions+=stack
set indentexpr=nvim_treesitter#indent()

" Shorten messages
set shortmess+=nocI

" Session options (using lua for complex assignment)
lua vim.o.sessionoptions = "buffers,curdir,winpos,winsize,terminal"

" General options
set nobackup
if exists('g:vscode')
  set cmdheight=2
else
  set cmdheight=1
endif
set laststatus=3
set completeopt=menuone,noselect
set conceallevel=0
set fileencoding=utf-8
set hlsearch
set ignorecase
set mouse=a
set pumheight=10
set noshowmode
set showtabline=0
set smartcase
set nosmartindent
set splitbelow
set splitright
set noswapfile
set undofile
set updatetime=700
set nowritebackup
set expandtab
set shiftwidth=2
set tabstop=2
set cursorline
set number
set relativenumber
set numberwidth=4
set signcolumn=yes
set noshowcmd
set nowrap
set scrolloff=8
set switchbuf=useopen,usetab
set sidescrolloff=8
set spelllang=en_us,pl

" Spell check (conditional based on vscode)
if !exists('g:vscode')
  set spell
else
  set nospell
endif

set spelloptions=camel,noplainbuffer
set spellcapcheck=
