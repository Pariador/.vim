if !exists('lightline_components')
    let lightline_components = {}
endif

let s:lc = lightline_components

if (has_key(lightline_components, 'load') && !lightline_components.load) ||
    \ (has_key(lightline_components, 'loaded') && lightline_components.loaded)
    finish
endif

let s:component_min_widths = {
    \ 'full_mode': 68,
    \ 'file_relativepath': 107,
    \ 'file_name': 30,
    \ 'flags': 40,
    \ 'filetype': 120,
    \ 'filedata': 140,
    \ 'percent': 63,
    \
    \ 'lineinfo_glyph': 56,
    \ 'lineinfo_max_lines': 56,
    \ 'lineinfo': 51,
    \
    \ 'noscrollbar': 93,
    \ 'nerd_tree_dir': 56,
    \ 'buffergator': 25,
    \
    \ 'readonly': 65,
    \ 'modified': 65,
\ }

function! s:GetSpecial()
    if exists('b:NERDTree')
        return 'NERDTree'
    elseif exists('b:buffergator_catalog_viewer')
        return 'Buffergator'
    elseif exists('b:plug_preview')
        return 'Plug'
    endif

    return ''
endfunction

" Mode
let s:mode_map = {
    \ 'n': 'NORMAL',
    \
    \ 'i': 'INSERT',
    \
    \ 'R': 'REPLACE',
    \ 'Rv': 'R-VIRTUAL',
    \
    \ 'v': 'VISUAL',
    \ 'V': 'V-LINE',
    \ '': 'V-BLOCK',
    \
    \ 's': 'SELECT',
    \ 'S': 'S-LINE',
    \ '': 'S-BLOCK',
    \
    \ 'c': 'COMMAND',
    \ 't': 'TERMINAL',
    \
    \ 'NERDTree': 'NERD',
    \ 'Buffergator': 'BUFFERS',
    \ 'Plug': 'Plug',
\ }

let s:brief_mode_map = {
    \ 'n': 'N',
    \
    \ 'i': 'I',
    \
    \ 'R': 'R',
    \ 'Rv': 'RV',
    \
    \ 'v': 'V',
    \ 'V': 'VL',
    \ '': 'VB',
    \
    \ 's': 'S',
    \ 'S': 'SL',
    \ '': 'SB',
    \
    \ 'c': 'C',
    \ 't': 'T',
    \
    \ 'NERDTree': 'NR',
    \ 'Buffergator': 'BF',
    \ 'Plug': 'Plug',
\ }

let s:lc.mode = {}

function! s:lc.mode.get() dict
    let l:default = 'n'

    let l:map = s:mode_map
    if winwidth(0) < s:component_min_widths.full_mode
        let l:map = s:brief_mode_map
    endif

    let l:mode = s:GetSpecial()

    let l:mode = l:mode == '' ? mode(1) : l:mode

    if has_key(l:map, l:mode)
        return l:map[l:mode]
    endif

    return l:map[l:default]
endfunction

" File
let s:lc.file = {}

function! s:lc.file.should_display() dict
    return s:GetSpecial() == ''
endfunction

function! s:lc.file.get() dict
    if !self.should_display() || winwidth(0) < s:component_min_widths.file_name
        return ''
    elseif winwidth(0) >= s:component_min_widths.file_relativepath
        return expand('%')
    else
        return expand('%:t')
    endif
endfunction

" Flags
function! s:StatusGetFlags()
    let l:flags = [
        \ &previewwindow ? 'PRV' : '',
        \ &buftype == 'help' ? 'HELP' : '',
        \ &readonly ? 'RO' : '',
        \ !&modifiable ? '-' : '',
        \ &modified ? '+' : '',
    \]

    return filter(l:flags, {i, value -> value != ''})
endfunction

let s:lc.flags = {}

function! s:lc.flags.should_display(...) dict
    if s:GetSpecial() != ''
        return 0
    endif

    if a:0
        let l:flags = a:1
    else
        let l:flags = s:StatusGetFlags()
    endif

    return !empty(l:flags)

endfunction

function! s:lc.flags.get() dict
    let l:flags = s:StatusGetFlags()

    if !self.should_display(l:flags) ||
        \ winwidth(0) < s:component_min_widths.flags
        return ''
    endif

    let l:flags = map(l:flags, {i, value ->
        \ printf(g:fat_bracket_format, value)
    \ })

    return join(l:flags, ' ')
endfunction

" FileType
let s:lc.filetype = {}

function! s:lc.filetype.should_display() dict
    return s:GetSpecial() == '' && &filetype != ''
endfunction

function! s:lc.filetype.get() dict
    if !self.should_display() || winwidth(0) < s:component_min_widths.filetype
        return ''
    endif

    return &filetype
endfunction

" FileData
let s:lc.filedata = {}

function! s:lc.filedata.should_display() dict
    if s:GetSpecial() != '' || (&fileencoding == '' && &fileformat == '')
        return 0
    endif

    return 1
endfunction

function! s:lc.filedata.get() dict
    if !self.should_display() || winwidth(0) < s:component_min_widths.filedata
        return ''
    endif

    let l:data = &fileencoding

    let l:data .= &fileformat == '' ? '' : '[' . &fileformat . ']'

    return l:data
endfunction

" Percent
let s:lc.percent = {}

function! s:lc.percent.should_display() dict
    return s:GetSpecial() == ''
endfunction

function! s:lc.percent.get() dict
    if !self.should_display() || winwidth(0) < s:component_min_widths.percent
        return ''
    endif

    let l:percent = ((line('.') * 1.0) / line('$')) * 100

    return printf('%3d%%', float2nr(l:percent))
endfunction

" LineInfo
let s:lc.lineinfo = {}

function! s:lc.lineinfo.should_display() dict
    let l:special = s:GetSpecial()
    return l:special == '' || l:special == 'Plug'
endfunction

function! s:lc.lineinfo.get() dict
    let l:winwidth = winwidth(0)

    if !self.should_display() || l:winwidth < s:component_min_widths.lineinfo
        return ''
    endif

    let l:line = printf('%02d', line('.'))
    let l:col = printf('%02d', col('.'))
    let l:glyph = ''
    let l:max_lines = ''

    if l:winwidth >= s:component_min_widths.lineinfo_glyph
        let l:glyph = '☰ '
    endif

    if l:winwidth >= s:component_min_widths.lineinfo_max_lines
        let l:max_lines = printf('/%d', line('$'))
    endif

    return printf('%s[%s%s : %s]', l:glyph, l:line, l:max_lines, l:col)
endfunction

" NoScrollbar
let s:lc.noscrollbar = {}

function! s:lc.noscrollbar.should_display() dict
    return s:GetSpecial() == ''
endfunction

function! s:lc.noscrollbar.get() dict
    if !self.should_display() ||
        \ winwidth(0) < s:component_min_widths.noscrollbar
        return ''
    endif

    return noscrollbar#statusline(20,'■','◫',['◧'],['◨'])
endfunction

" NERDTree
let s:lc.nerd_tree_dir = {}

function! s:lc.nerd_tree_dir.should_display() dict
    return s:GetSpecial() == 'NERDTree'
endfunction

function! s:lc.nerd_tree_dir.get() dict
    if !self.should_display() ||
        \ winwidth(0) < s:component_min_widths.nerd_tree_dir
        let g:dont = 1
        return ''
    endif

    return b:NERDTree.root.path.str()
endfunction

" Buffergator
let s:lc.buffergator = {}

function! s:lc.buffergator.should_display() dict
    return s:GetSpecial() == 'Buffergator'
endfunction

function! s:lc.buffergator.get() dict
    let l:line = line('.')

    if !self.should_display() ||
        \ winwidth(0) < s:component_min_widths.buffergator ||
        \ !has_key(b:buffergator_catalog_viewer.jump_map, l:line)
        return ''
    endif

    let l:buffers_count = len(b:buffergator_catalog_viewer.buffers_catalog)

    return printf('Buffer %d of %d', l:line, l:buffers_count)
endfunction

" Tabs
let s:lc.tabs = {}

function! s:GetTabNum(tab)
    return printf(g:fat_bracket_format, a:tab)
endfunction
let s:lc.tabs.get_tabnum = get(function('s:GetTabNum'), 'name')

function! s:GetWinCount(tab)
    let l:win_count = len(tabpagebuflist(a:tab))

    if l:win_count < 2
        return ''
    endif

    return printf('|%d|', l:win_count)
endfunction
let s:lc.tabs.get_wincount = get(function('s:GetWinCount'), 'name')

let s:lc.loaded = 1
