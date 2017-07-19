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

call neobundle#end()
NeoBundleCheck

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
syntax enable
colorscheme desert

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
    au BufRead,BufNewFile *.proto   setfiletype proto
    au BufNewFile,BufRead *.eyaml   setfiletype yaml
    au BufNewFile,BufRead *.sls     setfiletype yaml

    au BufWritePost *.py call Flake8()

    au FileType vim     set expandtab
    au FileType yaml    set ts=2 tw=2 autoindent
    au FileType markdown    set formatoptions+=l tw=0 linebreak
augroup end


map _ddate  i\section{:r!date +"\%A, \%B \%d, \%Y --- \%H:\%M}"<CR>kJxj
map _sig    :r!~mattp/bin/gensig<CR>
map _spell  :!ispell -S %<cr>:e %<cr>

"load powerline when it's available
py << EOF
try:
    from powerline.vim import setup as powerline_setup
    powerline_setup()
    del powerline_setup
except ImportError:
    pass
EOF
