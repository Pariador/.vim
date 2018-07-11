"------RUNTIMEPATH------
let $MYRUNTIME = "~/.vim"
let s:runtimes = [$VIMRUNTIME, $MYRUNTIME, $MYRUNTIME . "/after"]

let &runtimepath = join(s:runtimes, ",")

"------VIMINFO------
let &viminfo .= ",n" . $MYRUNTIME . "/viminfo"

"------GLOBALS------
let g:open_fat_bracket = "❰"
let g:close_fat_bracket = "❱"
let g:fat_bracket_format = g:open_fat_bracket . "%s" . g:close_fat_bracket

"------SETTINGS------
set encoding =utf-8 " Vim internal encoding.
set nocompatible " Vi compatibility
set notimeout " Unfinished mappings don't timeout.
syntax on
filetype plugin indent on " Enables filetype detection, filetype indenting, and filetype plugins.

" Indentation
set tabstop=4
set shiftwidth=4
set autoindent " See also smartindent, cindent and indentexpr.

" Folding
set foldlevelstart =99 " Open all folds when opening a file.
autocmd FileType javascript setlocal foldmethod=syntax

let &path = '.,,./**5,**5' " Directories for searching files with :find.
set backspace =indent " Allows you to backspace auto indent.
set nrformats -=octal " By default vim sees numbers with leading zeroes '003' as base 8, this makes it use decimal.

"------DISPLAY-SETTINGS------
set cursorline

" Line Numebers.
set number
set relativenumber

set noshowmode " Mode displayed in statusline
set showcmd " Shows the current command, at bottom right.
set wildmenu " Menu for command-line completion.
set foldcolumn =1

" Set indent guides.
set list
let &listchars = "tab:|\ " " For tabs.

" Search highlighting.
set hlsearch
set incsearch

set belloff =all " Silence Error Beeps.
" set showmatch " Move cursor to show matching brace while inserting.

" Windows
set splitright
set splitbelow

" Setup Status Line.
autocmd CmdlineEnter * redrawstatus " Redraw the status line after entering command-line mode.
set laststatus =2 " Make Status Line always visible.
let &statusline = "%f" " File Path.
let &statusline .= "     " " Padding.
let &statusline .= "%y" " File Type.
let &statusline .= "  " " Padding.
let &statusline .= "%m" " Modified.
let &statusline .= "  " " Padding.
let &statusline .= "%r" " Read-Only.
let &statusline .= "%=" " Switch to right side.
let &statusline .= "[%02.l, %02.c]" " Row and Col.
let &statusline .= "   " " Padding.
let &statusline .= "[%03.P]" " % of file on screen.

"------CONEMU-SETTINGS------
if  !empty($ConEmuPID)
	set term=xterm
	set t_Co=256
	let &t_AB="\e[48;5;%dm"
	let &t_AF="\e[38;5;%dm"
	colorscheme default

	" Fix Backspace.
	inoremap <Char-0x07F> <BS>
	nnoremap <Char-0x07F> <BS>
endif

"------PLUGINS------
source $MYRUNTIME/vimrc-plugins

"------VIM-MAPPINGS------
source $MYRUNTIME/vimrc-mappings

"------STUFF------
"function! Report(...)
"	let l:data = mode(1)
"	call append(0, l:data)
"endfunction
"function! StartReport()
"	call timer_start(1000, "Report", {"repeat": -1})
"endfunction
"------BUFFERLINE------
"let g:airline#extensions#bufferline#enabled = 0
"let g:airline#extensions#bufferline#overwrite_variables=1
"let g:bufferline_echo = 1
"let g:bufferline_active_buffer_left = '['
"let g:bufferline_active_buffer_right = ']'
"let g:bufferline_modified = '[+]'
"let g:bufferline_show_bufnr = 1
"let g:bufferline_rotate = 0

"let g:bufferline_solo_highlight = 0

"  let g:bufferline_echo = 0
"  autocmd VimEnter *
"    \ let &statusline='%{bufferline#refresh_status()}'
"      \ .bufferline#get_status_string()
