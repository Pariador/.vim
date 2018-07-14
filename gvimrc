"GVIM-PLUGINS are loaded and configured from plugins.vimrc

"------GVIM-MAPPINGS------
set mouse =a
set mousemodel =extend

map <2-RightMouse> <nop>
map <3-RightMouse> <nop>
map <4-RightMouse> <nop>

map <MiddleMouse> <nop>
map <2-MiddleMouse> <nop>
map <3-MiddleMouse> <nop>
map <4-MiddleMouse> <nop>

function! ToggleVisualKey()
	let l:mode = mode()
	echo l:mode
	if l:mode == 'v'
		return 'V'
	elseif l:mode == 'V'
		return "\<c-v>"
	elseif l:mode == "\<c-v>"
		return 'v'
	else
		return '\<nop\>'
	endif
endfunction

nnoremap <MiddleMouse> V
xnoremap <expr> <MiddleMouse> ToggleVisualKey()

noremap <silent> <F11> :GvimTweakToggleFullScreen<CR>

"------DISPLAY-SETTINGS------
set guioptions =c!

" Window position and size.
winpos 264 83
set lines =35
set columns =120

set winaltkeys =no "No alt keys for gui menus

set guifont =Hack:h9
colorscheme molokai_mod

"Set indent guides
let &listchars = "tab:┇\ " "For tabs
