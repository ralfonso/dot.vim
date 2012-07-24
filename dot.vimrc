let mapleader=","
set bg=dark
call pathogen#runtime_append_all_bundles()
set wildignore+=*.o,*obj,.git,*.pyc,static/assets/**,*.class

" this helps to throw onchange events for file watchers like Watchdog
set noswapfile

:highlight ExtraWhitespace ctermbg=red guibg=red
:match ExtraWhitespace /\s\+$/
:autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red

if has('gui_running')
    colorscheme solarized

    set guifont=Mensch:h12
	set guioptions-=T
	set guioptions+=g
	set guioptions+=i
	set guioptions+=t
	set guioptions-=L
	set guioptions-=l
	set guioptions+=r
	set guioptions+=e
	set guioptions+=p
	set cursorline
	set number

	" Control-Shift-PageUp drags the active tab page to the left (wraps around)
	imap <silent> <C-S-PageUp> <C-o>:call <Sid>DragLeft()<Cr>
	nmap <silent> <C-S-PageUp> :call <Sid>DragLeft()<Cr>

	function! s:DragLeft()
		let n = tabpagenr()
		execute 'tabmove' (n == 1 ? '' : n - 2)
		let &showtabline = &showtabline
	endfunction

	" Control-Shift-PageDown drags the active tab page to the right (wraps
	" around
	imap <silent> <C-S-PageDown> <C-o>:call <Sid>DragRight()<Cr>
	nmap <silent> <C-S-PageDown> :call <Sid>DragRight()<Cr>

	function! s:DragRight()
		let n = tabpagenr()
		execute 'tabmove' (n == tabpagenr('$') ? 0 : n)
		let &showtabline = &showtabline
	endfunction
endif

" encoding
set termencoding=utf-8
set encoding=utf-8

set nolist

" basic options
set cmdheight=1
set history=1000
set modeline
set nocompatible
set noerrorbells
set novisualbell
set shortmess+=aIt
set showcmd
set showfulltag
set showmatch
set showmode
set title
set titlestring=VIM:\ %<%F
set ttyfast
set undolevels=2000
set viminfo='1000,f1,:1000,/1000
set wildmenu

set nobackup
set nowritebackup
set noswapfile

" indent settings
set ai
set backspace=2
set shiftwidth=4
set tabstop=4

" folding
set foldmethod=marker
set mouse=a

" search options
set nocursorline
""set isk=@,48-57,_,192-255,-,.,@-@
set nohlsearch
set ignorecase

" set a toggle for pasting input
set pastetoggle=<F10>

" set bracket matching and comment formats
set matchpairs+=<:>
set comments-=s1:/*,mb:*,ex:*/
set comments+=s:/*,mb:**,ex:*/
set comments+=fb:*
set comments+=b:\"
set comments+=n::

" use less space for line numbering if possible
if v:version >= 700
	try
	setlocal numberwidth=3
		catch
	endtry
endif

" use css for generated html files
let html_use_css=1

" setup a funky statusline
set laststatus=0
set statusline=
set statusline+=%-3.3n\                      " buffer number
set statusline+=%t\                          " file name
set statusline+=%h%m%r%w                     " flags
set statusline+=\[%{strlen(&ft)?&ft:'none'}, " filetype
set statusline+=%{&fileencoding},            " fileencoding
set statusline+=%{&fileformat}]              " file format
set statusline+=%=                           " right align
set statusline+=0x%-8B\                      " current char
set statusline+=%-14.(%l,%c%V%)\ %<%P        " offset

" enable filetype detection
filetype on
filetype plugin on
set ofu=syntaxcomplete#Complete
""filetype indent on

set expandtab
set shiftwidth=4
set tabstop=4

augroup vimrcEX
    autocmd FileType html setlocal expandtab shiftwidth=2 tabstop=2
    autocmd FileType htmldjango setlocal expandtab shiftwidth=2 tabstop=2
    autocmd FileType phtml setlocal expandtab shiftwidth=2 tabstop=2
    autocmd FileType javascript setlocal expandtab shiftwidth=2 tabstop=2
    autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=4
    autocmd FileType clojure setlocal expandtab shiftwidth=2 tabstop=2
    autocmd FileType php setlocal expandtab shiftwidth=4 tabstop=4 omnifunc=phpcomplete#CompletePHP
    autocmd FileType xml setlocal expandtab shiftwidth=2 tabstop=2
    autocmd FileType ruby setlocal expandtab shiftwidth=2 tabstop=2
    autocmd FileType coffeescript setlocal expandtab shiftwidth=2 tabstop=2
        \ formatoptions+=croq softtabstop=2 smartindent
        \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
        \ list listchars=tab:>.,trail:.,extends:#,nbsp:.
    au BufRead,BufNewFile *.pp   setfiletype puppet

    " Jump to last cursor position unless it's invalid or in an event handler
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif
augroup END

let g:py_select_leading_comments = 0

" Make <space> in normal mode go down a page rather than left a character
"noremap <space> <C-f>

map <M-Left> :tabprev<CR>
map <M-Right> :tabnext<CR>
map <F9> :set number!<CR>
map <C-W>; :tabprev<CR>
map <C-W>' :tabnext<CR>
:nmap <C-t> :tabnew<cr>
:imap <C-t> <ESC>:tabnew<cr>

" enable syntax hilighting "
syntax on
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

map <Leader>v :tab sp ~/.vimrc<CR>
map <silent> <Leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" vbell on osx, which doesn't work anyway
set vb

runtime macros/matchit.vim

" load project-based tags
set tags=~/.vim/mytags/$PROJ

let vimfiles=$HOME . "/.vim"

function! Smart_TabComplete()
  let line = getline('.')                         " current line

  let substr = strpart(line, -1, col('.')+1)      " from the start of the current
                                                  " line to one character right
                                                  " of the cursor
  let substr = matchstr(substr, "[^ \t]*$")       " word till cursor
  if (strlen(substr)==0)                          " nothing to match on empty string
    return "\<tab>"
  endif
  let has_period = match(substr, '\.') != -1      " position of period, if any
  let has_slash = match(substr, '\/') != -1       " position of slash, if any
  if (!has_period && !has_slash)
    return "\<C-X>\<C-P>"                         " existing text matching
  elseif ( has_slash )
    return "\<C-X>\<C-F>"                         " file matching
  else
    return "\<C-X>\<C-O>"                         " plugin matching
  endif
endfunction

inoremap <tab> <c-r>=Smart_TabComplete()<CR>
