" Unfinished code for a bufferline-like plugin for the args list.
function EchoArgs()
    let l:args = argv()
    let l:i = argidx()

    let l:args[l:i] = printf(g:fat_bracket_format, l:args[l:i])

    echo join(l:args, ' ')
endfunction

function s:ChangeArg(direction)
    let l:count = v:count ? v:count : ''
    let l:command = a:direction ? 'n' : 'prev'

    let l:mapping = printf(":\<c-u>silent %s%s", l:count, l:command)
    let l:mapping .= "|call EchoArgs()\<cr>"

    return l:mapping
endfunction
