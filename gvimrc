"GVIM-PLUGINS are loaded and configured from plugins.vimrc

"------GVIM-MAPPINGS------
noremap <silent> <F11> :GvimTweakToggleFullScreen<CR>

"------DISPLAY-SETTINGS------
set guioptions -=m  "remove menu bar
set guioptions -=T  "remove toolbar
set guioptions -=r  "remove right-hand scroll bar
set guioptions -=L  "remove left-hand scroll bar
set guioptions -=e  "remove gui tab pages
set guioptions +=c  "use terminal style dialogs
set guioptions +=!  "use the vim command-line to execute ! commands

" Window position and size.
winpos 264 83
set lines =35
set columns =120

set winaltkeys =no "No alt keys for gui menus

set guifont =Hack:h9
colorscheme molokai_mod

"Set indent guides
let &listchars = "tab:┇\ " "For tabs
