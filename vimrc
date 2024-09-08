"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"
" vim: set tabstop=4 shiftwidth=4 fileencoding=utf8 expandtab;
"

set nocompatible        " Use VIM settings not vi; ** THIS MUST BE FIRST IN .VIMRC **
scriptencoding UTF-8    " interperet this script as UTF-8; redundant with the modeline

"______________________________________________________________________________________________
" GENERAL SETTINGS
"

set autoindent              " copy indent from the current line when beginning a new line
set backspace=2             " allow backspacing over everything in insert mode
set history=50              " keep 50 lines of command line history
set ignorecase              " case-insensitive search commands
set incsearch               " show search matched incrementally instead of waiting for <enter>
set mouse=a                 " allow mouse interactions
set number                  " line numbers at the side
set ruler                   " show the cursor position all the time
set shiftwidth=4            " pressing >> or << indents by X character
set tabstop=4               " a tab character intents to the Xth character
set viminfo='20,\"50        " read/write a .viminfo file, store no more than 50 lines 
set encoding=utf8           " non-ascii characters are encoded with UTF-8 by default
set expandtab               " pressing the tab key creates spaces
set formatoptions=croq      " c=autowrap comments
                            " r=continue comment on <enter>
                            " o=continue comment on <o> or <O>
                            " q=allow format comment with gqgq
set textwidth=0             " no forced wrapping in any file
set showcmd                 " show length of visual selection 
set complete=.,w,b,u        " make autocomplete faster
set splitright              " makes vertical splits to the right
set splitbelow              " creates horizontal splits below
set switchbuf=usetab        " when switching buffers, include tabs
set tabpagemax=30           " show up to X tabs
set hlsearch                " highlight search results
set diffopt+=vertical       " make diffsplit always vertical
set cryptmethod=blowfish    " use blowfish encryption for encrypted files
let g:netrw_mouse_maps=0    " ignore mouse clicks when browsing directories
set nowrap

set foldmethod=marker		" allow folding scopes by marker 


"______________________________________________________________________________________________
" MAPPINGS for noraml mode
"

" <F1> help
map <F1> :h

" <F2> open file in new tab
map <F2> :tabe

" <F3> save current file
map <F3> :w<CR>

" <F4> exit
map <F4> :q<CR>

" shift<F4> exit without saving
map <S-F4> :q!<CR>

" <F6> switch to next split
map <F6> <C-W><C-W>

" shift<F6> switch to previous split
map <S-F6> <C-W>W

" <F7> start search command, delimited by comma
nmap <F7> :%s,

" <F8> stop highlighting search results
map <F8> :noh<CR>

" <F9> change a setting
map <F9> :set

" shift<F9> change a setting, only in the current tab
map <S-F9> :setlocal

" <F12> toggle display of whitespace
nmap <F12> :set invlist<CR>

" <semicolon> same as <colon>
map ; :

" <space> toggles scope visibility
map <space> za

" <ctrl>g inserts an include guard
map <silent> <C-g> :call <SID>CreateCIncludeGuard()<CR>


"______________________________________________________________________________________________
" MAPPINGS for insert mode
"

" <F2> add another item to a comma-seperated list of strings
imap <F2> <RIGHT>, ""<LEFT>

" <F3> autocomplete, backward
inoremap <F3> <C-P>

" <F4> autocomplete, forward
inoremap <F4> <C-N>

" <F5> underscore (to save pinky finger)
map! <F5> _

" <F6> pair of curly braces, continue typing inside them
map! <F6> {}<LEFT>

" <F7> pair of parentheses, continue typing after them
map! <F7> ()

" <F8> pair of parentheses, continue typing inside them
map! <F8> ()<LEFT>

" <F9> pair of parentheses with extra spaces inside
map! <F9> (  )<LEFT><LEFT>

" <F10> pair of double quotes, type inside them
map! <F10> ""<LEFT>

" shift<F10> pair of single quotes, type inside them
map! <S-F10> ''<LEFT>

" <F11> pair of square brackets, type inside them
map! <F11> []<LEFT>

" <F12> pair of angle brackets, type inside them
map! <F12> <><LEFT>


"______________________________________________________________________________________________
" FUNCTIONS
"

function! s:CreateCIncludeGuard()
	let randlen = 6
	let randnum = system("xxd -c" . randlen*2 . " -l " .randlen . " -p /dev/urandom")
	let randum = strpart(randnum, 0, randlen*2)
	let fname = expand("%")
	let lastslash = strridx(fname, "/")

	if lastslash >= 0
		let fname = strpart(fname, lastslash+1)
	endif

	let fname = substitute(fname, "[^a-zA-Z0-9]", "_", "g")
	let randid = toupper(fname . "_" .randnum)
	
	exec 'norm O#ifndef ' . randid
	norm kkdd
	exec 'norm o#define ' . randid
	let origin = getpos('.')
	exec '$norm o#endif // ' . randid
	norm dd
	call setpos('.', origin)
	norm yypp
	startinsert
endfunction


"______________________________________________________________________________________________
" PLUGINS
"

if exists(":EasyAlign")
	nmap g<tab> <Plug>(EasyAlign)
	xmap g<tab> <Plug>(EasyAlign)
endif


"______________________________________________________________________________________________
" COLORS 
"

if &t_Co > 2 || has("gui_running")
	try
		colorscheme molokai
	catch /^Vim\%((\a\+)\)\=:E185/
		colorscheme slate
	endtry

	syntax on
endif


"______________________________________________________________________________________________
" GUI OPTIONS - only affects gvim
"

if has ("gui_running")
	au GUIEnter * simalt ~x	" start maximized
	set guioptions-=T		" no toolbar
	set guioptions-=m		" no menus
	set guioptions-=L		" no left scrollbar
	set guioptions-=r		" no right scrollbar
endif


"______________________________________________________________________________________________
" AUTOMATIC BACKUP FILES
"
"
" Enable backup files. Every time you save a file, it will create a copy of the file called
" <filename>~ in the directory ~/.vim_backup_files/.
"

let &backupdir=($HOME . '/.vim_backup_files')
if ! isdirectory(&backupdir)
	call mkdir(&backupdir, "", 0700)
endif
set backup
