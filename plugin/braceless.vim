if exists('g:loaded_braceless') && g:loaded_braceless
    finish
en

let s:cpo_save = &cpo
set cpo&vim

let s:base = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')
let s:did_init = 0
let s:nomodline_avail = v:version > 703 || (v:version == 703 && has('patch438'))
let g:loaded_braceless = 1


let g:braceless#key#segment_prev = get(g:, 'braceless_segment_prev_key', 'k')
let g:braceless#key#segment_next = get(g:, 'braceless_segment_next_key', 'j')
let g:braceless#key#block = get(g:, 'braceless_block_key', 'P')
let g:braceless#key#jump_prev = get(g:, 'braceless_jump_prev_key', '[')
let g:braceless#key#jump_next = get(g:, 'braceless_jump_next_key', ']')
let g:braceless#key#em_prev = get(g:, 'braceless_easymotion_prev_key', g:braceless#key#jump_prev)
let g:braceless#key#em_next = get(g:, 'braceless_easymotion_next_key', g:braceless#key#jump_next)
let g:braceless#key#em_segment = get(g:, 'braceless_easymotion_segment_key', 'S')


fun! s:enable(...)
    if !s:did_init
        let s:did_init = 1
        if s:nomodline_avail
            silent doautocmd <nomodeline> User BracelessInit
        el
            silent doautocmd User BracelessInit
        en
    en

    let b:braceless_enabled = 1

    if !empty(g:braceless#key#segment_prev) && !empty(g:braceless#key#segment_next)
        exe  'map <buffer> ['.g:braceless#key#segment_prev.' <Plug>(braceless-segment-prev-top-n)'
        exe  'map <buffer> ]'.g:braceless#key#segment_prev.' <Plug>(braceless-segment-prev-bot-n)'
        exe  'map <buffer> ['.g:braceless#key#segment_next.' <Plug>(braceless-segment-next-top-n)'
        exe  'map <buffer> ]'.g:braceless#key#segment_next.' <Plug>(braceless-segment-next-bot-n)'

        exe  'vmap <buffer> ['.g:braceless#key#segment_prev.' <Plug>(braceless-segment-prev-top-v)'
        exe  'vmap <buffer> ]'.g:braceless#key#segment_prev.' <Plug>(braceless-segment-prev-bot-v)'
        exe  'vmap <buffer> ['.g:braceless#key#segment_next.' <Plug>(braceless-segment-next-top-v)'
        exe  'vmap <buffer> ]'.g:braceless#key#segment_next.' <Plug>(braceless-segment-next-bot-v)'
    en

    if !empty(g:braceless#key#block)
        exe  'vmap <buffer> i'.g:braceless#key#block.' <Plug>(braceless-i-v)'
        exe  'vmap <buffer> a'.g:braceless#key#block.' <Plug>(braceless-a-v)'
        exe  'omap <buffer> i'.g:braceless#key#block.' <Plug>(braceless-i-n)'
        exe  'omap <buffer> a'.g:braceless#key#block.' <Plug>(braceless-a-n)'
    en

    if !empty(g:braceless#key#jump_prev)
        exe  'map <buffer> ['.g:braceless#key#jump_prev.' <Plug>(braceless-jump-prev-n)'
        exe  'vmap <buffer> ['.g:braceless#key#jump_prev.' <Plug>(braceless-jump-prev-v)'
    en

    if !empty(g:braceless#key#jump_next)
        exe  'map <buffer> ]'.g:braceless#key#jump_next.' <Plug>(braceless-jump-next-n)'
        exe  'vmap <buffer> ]'.g:braceless#key#jump_next.' <Plug>(braceless-jump-next-v)'
    en

    if get(g:, 'braceless_enable_jump_indent', 0)
        exe  'map <buffer> g'.g:braceless#key#jump_prev.' <Plug>(braceless-jump-prev-n-indent)'
        exe  'vmap <buffer> g'.g:braceless#key#jump_prev.' <Plug>(braceless-jump-prev-v-indent)'
        exe  'map <buffer> g'.g:braceless#key#jump_next.' <Plug>(braceless-jump-next-n-indent)'
        exe  'vmap <buffer> g'.g:braceless#key#jump_next.' <Plug>(braceless-jump-next-v-indent)'
    en

    if get(g:, 'braceless_enable_easymotion', 1)
        if !empty(g:braceless#key#block)
            silent execute 'map <buffer> <Plug>(easymotion-prefix)'.g:braceless#key#block.' :<C-u>call braceless#easymotion#blocks(0, 2)<cr>'
            silent execute 'xmap <buffer> <Plug>(easymotion-prefix)'.g:braceless#key#block.' :<C-u>call braceless#easymotion#blocks(1, 2)<cr>'
        en

        if !empty(g:braceless#key#em_prev)
            silent execute 'map <buffer> <Plug>(easymotion-prefix)'.g:braceless#key#em_prev.' :<C-u>call braceless#easymotion#blocks(0, 1)<cr>'
            silent execute 'xmap <buffer> <Plug>(easymotion-prefix)'.g:braceless#key#em_prev.' :<C-u>call braceless#easymotion#blocks(1, 1)<cr>'
        en

        if !empty(g:braceless#key#em_next)
            silent execute 'map <buffer> <Plug>(easymotion-prefix)'.g:braceless#key#em_next.' :<C-u>call braceless#easymotion#blocks(0, 0)<cr>'
            silent execute 'xmap <buffer> <Plug>(easymotion-prefix)'.g:braceless#key#em_next.' :<C-u>call braceless#easymotion#blocks(1, 0)<cr>'
        en

        if !empty(g:braceless#key#em_segment)
            silent execute 'map <buffer> <Plug>(easymotion-prefix)'.g:braceless#key#em_segment.' :<C-u>call braceless#easymotion#segments(0, 2)<cr>'
            silent execute 'xmap <buffer> <Plug>(easymotion-prefix)'.g:braceless#key#em_segment.' :<C-u>call braceless#easymotion#segments(1, 2)<cr>'
        en
    en

    if !exists('b:braceless')
        let b:braceless = {}
    en

    let b:braceless.fold_cache = {}
    let b:braceless.fold_changedtick = b:changedtick + 1
    let b:braceless.indent_enabled = 0

    call braceless#highlight#enable(0)

    if has_key(b:braceless, 'foldmethod')
        let &l:foldmethod = b:braceless.foldmethod
    en

    if has_key(b:braceless, 'foldexpr')
        let &l:foldexpr = b:braceless.foldexpr
    en

    if has_key(b:braceless, 'orig_cc')
        let &l:cc = b:braceless.orig_cc
    en

    if has_key(b:braceless, 'indentexpr')
        let &l:indentexpr = b:braceless.indentexpr
    en

    for opt in a:000
        if opt =~ '^+fold'
            if opt !~ '-slow'
                let b:braceless.foldmethod = &l:foldmethod
                call braceless#fold#enable_fast()
            el
                " Depreciated
                if opt =~ '-inner'
                    let b:braceless.fold_inner = 1
                el
                    let b:braceless.fold_inner = 0
                en

                let b:braceless.foldmethod = &l:foldmethod
                let b:braceless.foldexpr = &l:foldexpr

                setl  foldmethod=expr
                setl  foldexpr=braceless#fold#expr(v:lnum)
            en
        elseif opt =~ '^+highlight'
            if opt[-3:] == '-cc'
                let b:braceless.highlight_cc = 1
            elseif opt[-4:] == '-cc2'
                let b:braceless.highlight_cc = 2
            el
                let b:braceless.highlight_cc = 0
            en
            call braceless#highlight#enable(1)
        elseif opt =~ '^+indent'
            let b:braceless.indent_enabled = 1
            let b:braceless.indentexpr = &l:indentexpr
            setl  indentexpr=braceless#indent#expr(v:lnum)

            let setup_func = 'braceless#'.&l:filetype.'#setup_indent'
            silent! call call(setup_func, [])

            if get(g:, 'braceless_generate_scripts', 0)
                " Generate a plugin indent script that overrides indent scripts if
                " braceless was enabled from an ftplugin script.
                let indent_script = join([s:base, 'after/indent/'.&l:filetype.'.vim'], '/')
                if filewritable(fnamemodify(indent_script, ':h')) == 2 && !filereadable(indent_script)
                    call writefile([
                                \ 'if exists("b:braceless") && b:braceless.indent_enabled && &l:indentexpr !~ "braceless#"',
                                \ '  setl  indentexpr=braceless#indent#expr(v:lnum)',
                                \ '  silent! call '.setup_func.'()',
                                \ 'endif',
                                \ ], indent_script)
                en
            en
        en
    endfor

    exe  'silent doautocmd '.(s:nomodline_avail ? '<nomodeline>' : '').' User BracelessEnabled_'.&l:filetype
endf


fun! s:set_highlight()
    hi default BracelessIndent ctermfg=3 cterm=inverse guifg=#e4b65b gui=inverse
endf


fun! s:init()
    if !exists('g:braceless_format')
        let g:braceless_format = {}
    en

    " Text object
    vno  <silent> <Plug>(braceless-i-v) :<C-u>call braceless#motion#select('i', '')<cr>
    vno  <silent> <Plug>(braceless-a-v) :<C-u>call braceless#motion#select('a', '')<cr>
    onoremap <silent> <Plug>(braceless-i-n) :<C-u>call braceless#motion#select('i', v:operator)<cr>
    onoremap <silent> <Plug>(braceless-a-n) :<C-u>call braceless#motion#select('a', v:operator)<cr>

    " Segment movement
    no  <silent> <Plug>(braceless-segment-prev-top-n) :<C-u>silent call braceless#segments#move(-1, 1, 'n', v:operator)<cr>
    no  <silent> <Plug>(braceless-segment-prev-bot-n) :<C-u>silent call braceless#segments#move(-1, 0, 'n', v:operator)<cr>
    no  <silent> <Plug>(braceless-segment-next-top-n) :<C-u>silent call braceless#segments#move( 1, 1, 'n', v:operator)<cr>
    no  <silent> <Plug>(braceless-segment-next-bot-n) :<C-u>silent call braceless#segments#move( 1, 0, 'n', v:operator)<cr>

    vno  <silent> <Plug>(braceless-segment-prev-top-v) :<C-u>silent call braceless#segments#move(-1, 1, visualmode(), v:operator)<cr>
    vno  <silent> <Plug>(braceless-segment-prev-bot-v) :<C-u>silent call braceless#segments#move(-1, 0, visualmode(), v:operator)<cr>
    vno  <silent> <Plug>(braceless-segment-next-top-v) :<C-u>silent call braceless#segments#move( 1, 1, visualmode(), v:operator)<cr>
    vno  <silent> <Plug>(braceless-segment-next-bot-v) :<C-u>silent call braceless#segments#move( 1, 0, visualmode(), v:operator)<cr>

    " Simple block movement
    vno  <silent> <Plug>(braceless-jump-prev-v) :<C-u>call braceless#movement#block(-1, visualmode(), 0, v:count1)<cr>
    vno  <silent> <Plug>(braceless-jump-next-v) :<C-u>call braceless#movement#block(1, visualmode(), 0, v:count1)<cr>
    vno  <silent> <Plug>(braceless-jump-prev-v-indent) :<C-u>call braceless#movement#block(-1, visualmode(), 1, v:count1)<cr>
    vno  <silent> <Plug>(braceless-jump-next-v-indent) :<C-u>call braceless#movement#block(1, visualmode(), 1, v:count1)<cr>

    no  <silent> <Plug>(braceless-jump-prev-n) :<C-u>call braceless#movement#block(-1, 'n', 0, v:count1)<cr>
    no  <silent> <Plug>(braceless-jump-next-n) :<C-u>call braceless#movement#block(1, 'n', 0, v:count1)<cr>
    no  <silent> <Plug>(braceless-jump-prev-n-indent) :<C-u>call braceless#movement#block(-1, 'n', 1, v:count1)<cr>
    no  <silent> <Plug>(braceless-jump-next-n-indent) :<C-u>call braceless#movement#block(1, 'n', 1, v:count1)<cr>
endf


aug  braceless_plugin
    au!
    au User BracelessEnabled_python call braceless#python#init()
    au ColorScheme * call s:set_highlight()
aug  END

call s:set_highlight()
call s:init()
com!  -nargs=* BracelessEnable call s:enable(<f-args>)

let &cpo = s:cpo_save
unlet s:cpo_save
