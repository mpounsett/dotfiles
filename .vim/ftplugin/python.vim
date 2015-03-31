set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
filetype indent on

:highlight BadWhitespace ctermbg=red guibg=red
" Display tabs at the beginning of a line in Python mode as bad.
match BadWhitespace /^\t\+/
" Make trailing whitespace be flagged as bad.
match BadWhitespace /\s\+$/


