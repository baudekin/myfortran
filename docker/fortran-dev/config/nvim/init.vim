set runtimepath^=~/.vim/ runtimepath+=~/.vim/after
let &packpath = &runtimepath

call plug#begin(stdpath('data') . '/plugged')

"https://github.com/easymotion/vim-easymotion "
"Plug 'easymotion/vim-easymotion'
"Less annoying completion preveiw https://github.com/ncm2/float-preview.nvim"
Plug 'ncm2/float-preview.nvim'
"Support float-priview https://github.com/liuchengxu/vim-clap"
Plug 'liuchengxu/vim-clap'
"Manage bracket, aprens quotes in pair https://github.com/jiangmiao/auto-pairs"
"Plug 'jiangmiao/auto-pairs', { 'tag': 'v2.0.0' }
"Code snippet solution https://github.com/SirVer/ultisnips"
Plug 'SirVer/ultisnips'
"Async syntax checker https://github.com/dense-analysis/ale"
Plug 'w0rp/ale'
"Intellisense engine https://github.com/neoclide/coc.nvim"
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Fortran IDE https://rudrab.github.io/vimf90/"
Plug 'rudrab/vimf90'
"Warm Desert Color scheme https://github.com/rainux/vim-desert-warm-256"
Plug 'rainux/vim-desert-warm-256'

call plug#end()

" --- Text Formatting ---
filetype plugin indent on
syntax on
set nowrap
set textwidth=79
set formatoptions=n

if exists("+colorcolumn")
  set colorcolumn=80
endif


" Fortran Settings
" Neovim indent see https://github.com/neovim/neovim/blob/master/runtime/doc/indent.txt
" and help ft-fortran-syntax
let g:fortran_fold=1         " Enable prog, subprog, func, subroutines foldering
let g:fortran_fold_conditionls=1 " Enable loop foldering
let g:fortran_fold_multilinecomments=0  "Disable multile comments folding
let g:fortran_more_precise=1 " Syntax highlight labels "slows things down!!"
let g:fortran_do_enddo=1
let g:fortran_indent_less=1
let g:fortran_have_tabs=1    " Tabs are evils never allow in fortran

" vimf90
let g:VimF90Leader = "`"
let g:VimF90Linter = 1

" Choose the correct file settings for give fortran version
let s:extfname = expand("%:e")
if s:extfname ==? "f90"
  unlet! b:fortran_dialect
  let b:fortran_free_source=1  " Always assume always free-form for F90 and above
  set wrap
elseif s:extfname =~ "[F,f][0-9][0-9]"
  let b:fortran_dialect="F"
  let b:fortran_free_source=0
  set wrap
  if exists("+colorcolumn")
    set colorcolumn=64
    set textwidth=63
    set formatoptions="tc"
  endif
endif

" Neovim indetnt C/C++ settings
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set smartindent
set expandtab
set shiftround

set completeopt=noinsert,noselect,menuone

" GUI 
set t_Co=256
set background=dark
colorscheme desert-warm-256
set number


" --- Display Trailing White Spaces ---"
set list listchars=tab:▷⋅,trail:⋅,nbsp:⋅"


" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%F\ %l\:%c%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
