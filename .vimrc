:version 6.1
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
syntax enable

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
	au! BufRead,BufNewFile *.proto setfiletype proto
augroup end

au BufNewFile,BufRead *.eyaml setfiletype yaml


colorscheme desert
"colorscheme darkblue
" hi Comment  term=bold ctermfg=darkgreen guifg=darkgreen
" syn region texZone	start="\\begin{command}"		end="\\end{command}\|%stopzone\>"
" syn region texZone	start="\\begin{response}"		end="\\end{response}\|%stopzone\>"
"     hi Constant term=underline ctermfg=Magenta guifg=Magenta
"     hi Special  term=bold ctermfg=LightRed guifg=SlateBlue
"     hi Identifier term=underline ctermfg=DarkCyan guifg=DarkCyan
"     hi Statement term=bold ctermfg=Brown gui=bold guifg=Brown
"     hi PreProc  term=underline ctermfg=Magenta guifg=Purple
"     hi Type     term=underline ctermfg=DarkGreen guifg=SeaGreen gui=bold

map _ddate	i\section{:r!date +"\%A, \%B \%d, \%Y --- \%H:\%M}"<CR>kJxj
map _sig	:r!~mattp/bin/gensig<CR>
map _spell	:!ispell -S %<cr>:e %<cr>

if !1 | finish | endif

if has('vim_starting')
	if &compatible
		set nocompatible
	endif

	set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'

call neobundle#end()
NeoBundleCheck
