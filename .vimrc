:version 8.0

if !1 | finish | endif

if has('vim_starting')
    if &compatible
        set nocompatible
    endif

    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'fatih/vim-go'
NeoBundle 'nvie/vim-flake8'
NeoBundle 'ekalinin/Dockerfile.vim'
NeoBundle 'toyamarinyon/vim-swift'
NeoBundle 'saltstack/salt-vim'
NeoBundle 'Glench/Vim-Jinja2-Syntax'
NeoBundle 'momota/cisco.vim'

call neobundle#end()
NeoBundleCheck

let g:go_version_warning=0

set encoding=utf-8
set tw=78
set nobk
set showmode
set ruler
set showcmd
set backspace=2
set history=50
set noicon
set laststatus=2
set shiftwidth=4
set sidescroll=8
set tabstop=4
set notitle
set wrap
set wrapmargin=0
set nowrapscan
set bg=dark
set modeline
set modelines=4
set formatoptions-=l
set list
set showbreak=↪\
"set listchars=nbsp:•,tab:«·»,trail:·
set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:␣,trail:·,eol:↲
hi NonText ctermfg=16 guifg=#4a4a59
hi SpecialKey ctermfg=16 guifg=#4a4a59

syntax enable
colorscheme desert
hi Search term=reverse ctermfg=black ctermbg=12 guifg=wheat guibg=peru

if &term == "xterm-color"
    set t_kb=
    fixdel
endif
if &term == "xterm"
    set t_kb=
    fixdel
endif

filetype plugin indent on

augroup filetype
    au!
    au BufNewFile,BufRead *.eyaml   setfiletype yaml
    au BufNewFile,BufRead *.j2      setfiletype jinja
    au BufNewFile,BufRead *.jinja   setfiletype jinja
    au BufRead,BufNewFile *.proto   setfiletype proto
    au BufRead,BufNewFile *.sls     setfiletype yaml
    " Magick Vector Graphics
    au BufNewFile,BufRead *.mvg     setfiletype mvg


    au BufWritePost *.py call Flake8()

    au FileType apache      set ts=2 sw=2 autoindent expandtab
    au FileType bindzone    set ts=4 sw=4 autoindent expandtab
    au FileType css         set ts=3 sw=3 autoindent expandtab
    au FileType mail        set formatoptions-=l linebreak expandtab autoindent
    au FileType html        set ts=3 sw=3 autoindent expandtab
    au FileType htmldjango  set ts=2 sw=2 autoindent expandtab
    au FileType icinga2     set ts=2 sw=2 autoindent expandtab
    au FileType json        set ts=2 sw=2 fo-=l fo+=t expandtab autoindent
    au FileType markdown    set formatoptions-=l linebreak expandtab autoindent
    au FileType mvg         set ts=2 sw=2 autoindent expandtab
    au FileType rst         set formatoptions-=l linebreak expandtab autoindent
    au FileType salt        set ts=2 sw=2 fo-=l fo+=t expandtab autoindent
    au FileType sh          set formatoptions-=l linebreak expandtab autoindent
    au FileType tex         set ts=3 sw=3 autoindent expandtab
    au FileType toml        set ts=4 sw=4 fo-=l fo+=t expandtab autoindent
    au FileType vim         set expandtab
    au FileType yaml        set ts=2 sw=2 fo-=l fo+=t expandtab autoindent
augroup end


map _ddate  i\section{:r!date +"\%A, \%B \%d, \%Y --- \%H:\%M}"<CR>kJxj
map _sig    :r!~mattp/bin/gensig<CR>
map _spell  :w<cr>:!ispell -S %<cr>:e %<cr>

"load powerline when it's available
if has('python')
py << EOF
try:
    from powerline.vim import setup as powerline_setup
    powerline_setup()
    del powerline_setup
except ImportError:
    pass
EOF
elseif has('python3')
py3 << EOF
try:
    from powerline.vim import setup as powerline_setup
    powerline_setup()
    del powerline_setup
except ImportError:
    pass
EOF
endif
