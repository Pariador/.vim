let s:textwidth_marker_defaults = {
    \ 'loaded': 0, 
    \ 'enabled': 1,
    \ 'match_priority': -10,
    \ 'highlight_group': 'TextWidthMarker'
\ }

if exists('g:textwidth_marker')
    for key in keys(s:textwidth_marker_defaults)
        if !has_key(g:textwidth_marker, key)
            let g:textwidth_marker[key] = s:textwidth_marker_defaults[key]
        endif
    endfor
else
    let g:textwidth_marker = s:textwidth_marker_defaults
endif

if !g:textwidth_marker.enabled || g:textwidth_marker.loaded
    finish
endif

if !hlexists(g:textwidth_marker.highlight_group)
    exec 'highlight clear ' . g:textwidth_marker.highlight
endif

function! TextWidthMarkerEnable()
    if !exists('w:textwidth_marker') || w:textwidth_marker.enabled
        return
    endif

    let w:textwidth_marker.enabled = 1

    let l:pattern = printf('\%%%dv.\+', w:textwidth_marker.width)

    let w:textwidth_marker.match_id = matchadd(
        \ 'TextWidthMarker',
        \ l:pattern,
        \ g:textwidth_marker.match_priority,
        \ w:textwidth_marker.match_id
    \ )
endfunction

function! TextWidthMarkerDisable()
    if !exists('w:textwidth_marker') || !w:textwidth_marker.enabled
        return
    endif

    let w:textwidth_marker.enabled = 0

    call matchdelete(w:textwidth_marker.match_id)
endfunction

function! TextWidthMarkerSet(width)
    if exists('w:textwidth_marker')
        call TextWidthMarkerDisable()
    else
        let w:textwidth_marker = {
            \ 'enabled': 0,
            \ 'match_id': -1
        \ }
    endif

    let w:textwidth_marker.width = a:width + 1

    call TextWidthMarkerEnable()
endfunction

function! TextWidthMarkerToggle()
    if !exists('w:textwidth_marker')
        return
    endif

    if w:textwidth_marker.enabled
        call TextWidthMarkerDisable()
    else
        call TextWidthMarkerEnable()
    endif
endfunction

command TextWidthMarkerEnable call TextWidthMarkerEnable()
command TextWidthMarkerDisable call TextWidthMarkerDisable()
command -nargs=1 TextWidthMarkerSet call TextWidthMarkerSet(<f-args>)
command TextWidthMarkerToggle call TextWidthMarkerToggle()

let g:textwidth_marker.loaded = 1
