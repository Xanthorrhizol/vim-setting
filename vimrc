" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
let s:using_snippets = 1

" vim-plug: {{{
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

" Unmanaged plugin (manually installed and updated)
Plug '~/my-prototype-plugin'

" Rust
Plug 'rust-lang/rust.vim'

" bpftrace
Plug 'mmarchini/bpftrace.vim'

" python
Plug 'davidhalter/jedi-vim'

" go
"Plug 'fatih/vim-go',{ 'do': ':GoUpdateBinaries' }

" OmniSharp
Plug 'OmniSharp/omnisharp-vim'

" Mappings, code-actions available flag and statusline integration
Plug 'nickspoons/vim-sharpenup'

" Linting/error highlighting
Plug 'dense-analysis/ale'

" Vim FZF integration, used as OmniSharp selector
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Autocompletion
Plug 'prabirshrestha/asyncomplete.vim'

" Colorscheme
Plug 'gruvbox-community/gruvbox'

" Statusline
Plug 'itchyny/lightline.vim'
Plug 'shinchu/lightline-gruvbox.vim'
Plug 'maximbaz/lightline-ale'

" Snippet support
if s:using_snippets
  Plug 'sirver/ultisnips'
endif

" indent
Plug 'nathanaelkane/vim-indent-guides'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()
" }}}

" Settings: {{{
filetype indent plugin on
if !exists('g:syntax_on') | syntax enable | endif
set encoding=utf-8
scriptencoding utf-8

syntax enable

set completeopt=menu,menuone,preview,noinsert,noselect,popuphidden
set completepopup=highlight:Pmenu,border:off

set backspace=indent,eol,start
set expandtab
set shiftround
"set textwidth=80
set title

set hidden
set nofixendofline
set nostartofline
set splitbelow
set splitright

set hlsearch
set incsearch
set laststatus=2
set nonumber
set noruler
set noshowmode
set signcolumn=yes

set mouse=a
set updatetime=1000
" }}}

" Colors: {{{
augroup ColorschemePreferences
  autocmd!
  " These preferences clear some gruvbox background colours, allowing transparency
  autocmd ColorScheme * highlight Normal     ctermbg=NONE guibg=NONE
  autocmd ColorScheme * highlight SignColumn ctermbg=NONE guibg=NONE
  autocmd ColorScheme * highlight Todo       ctermbg=NONE guibg=NONE
  " Link ALE sign highlights to similar equivalents without background colours
  autocmd ColorScheme * highlight link ALEErrorSign   WarningMsg
  autocmd ColorScheme * highlight link ALEWarningSign ModeMsg
  autocmd ColorScheme * highlight link ALEInfoSign    Identifier
augroup END

" Use truecolor in the terminal, when it is supported
if has('termguicolors')
  set termguicolors
endif

set background=dark
colorscheme gruvbox
" }}}

" ALE: {{{
let g:ale_sign_error = '•'
let g:ale_sign_warning = '•'
let g:ale_sign_info = '·'
let g:ale_sign_style_error = '·'
let g:ale_sign_style_warning = '·'
let g:ale_completion_enabled = 1

let g:ale_linters = { 'cs': ['OmniSharp'], 'rust': ['analyzer'] }
let g:ale_fixers = { 'rust': ['trim_whitespace', 'remove_trailing_lines', 'rustfmt'] } 

" rust
let g:rustfmt_autosave = 0
let g:ale_rust_cargo_use_clippy = 0
let g:syntastic_rust_checkers = ['cargo']
" }}}

" Asyncomplete: {{{
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 0
" }}}

" Sharpenup: {{{
" All sharpenup mappings will begin with `<Space>os`, e.g. `<Space>osgd` for
" :OmniSharpGotoDefinition
let g:sharpenup_map_prefix = '<Space>os'

let g:sharpenup_statusline_opts = { 'Text': '%s (%p/%P)' }
let g:sharpenup_statusline_opts.Highlight = 0

augroup OmniSharpIntegrations
  autocmd!
  autocmd User OmniSharpProjectUpdated,OmniSharpReady call lightline#update()
augroup END
" }}}

" Lightline: {{{
let g:lightline = {
\ 'colorscheme': 'gruvbox',
\ 'active': {
\   'right': [
\     ['linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok'],
\     ['lineinfo'], ['percent'],
\     ['fileformat', 'fileencoding', 'filetype', 'sharpenup']
\   ]
\ },
\ 'inactive': {
\   'right': [['lineinfo'], ['percent'], ['sharpenup']]
\ },
\ 'component': {
\   'sharpenup': sharpenup#statusline#Build()
\ },
\ 'component_expand': {
\   'linter_checking': 'lightline#ale#checking',
\   'linter_infos': 'lightline#ale#infos',
\   'linter_warnings': 'lightline#ale#warnings',
\   'linter_errors': 'lightline#ale#errors',
\   'linter_ok': 'lightline#ale#ok'
  \  },
  \ 'component_type': {
  \   'linter_checking': 'right',
  \   'linter_infos': 'right',
  \   'linter_warnings': 'warning',
  \   'linter_errors': 'error',
  \   'linter_ok': 'right'
\  }
\}
" Use unicode chars for ale indicators in the statusline
let g:lightline#ale#indicator_checking = "\uf110 "
let g:lightline#ale#indicator_infos = "\uf129 "
let g:lightline#ale#indicator_warnings = "\uf071 "
let g:lightline#ale#indicator_errors = "\uf05e "
let g:lightline#ale#indicator_ok = "\uf00c "
" }}}

" OmniSharp: {{{
let g:OmniSharp_popup_position = 'peek'
if has('nvim')
  let g:OmniSharp_popup_options = {
  \ 'winblend': 30,
  \ 'winhl': 'Normal:Normal,FloatBorder:ModeMsg',
  \ 'border': 'rounded'
  \}
else
  let g:OmniSharp_popup_options = {
  \ 'highlight': 'Normal',
  \ 'padding': [0],
  \ 'border': [1],
  \ 'borderchars': ['─', '│', '─', '│', '╭', '╮', '╯', '╰'],
  \ 'borderhighlight': ['ModeMsg']
  \}
endif
let g:OmniSharp_popup_mappings = {
\ 'sigNext': '<C-n>',
\ 'sigPrev': '<C-p>',
\ 'pageDown': ['<C-f>', '<PageDown>'],
\ 'pageUp': ['<C-b>', '<PageUp>']
\}

if s:using_snippets
  let g:OmniSharp_want_snippet = 1
endif

let g:OmniSharp_highlight_groups = {
\ 'ExcludedCode': 'NonText'
\}
" }}}

" indent
filetype plugin indent on
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 1
let python_highlight_all = 1

if has('autocmd')
    set autoindent
    set cursorcolumn
    set cursorline
    set expandtab
    set foldmethod=marker
    filetype on
    autocmd FileType typescript setlocal tabstop=2 shiftwidth=2
    autocmd FileType javascript setlocal tabstop=2 shiftwidth=2
    autocmd FileType sh setlocal tabstop=2 shiftwidth=2
    autocmd FileType proto setlocal tabstop=2 shiftwidth=2
    autocmd FileType rust setlocal tabstop=4 shiftwidth=4
    autocmd FileType groovy setlocal tabstop=4 shiftwidth=4
    autocmd FileType c setlocal tabstop=4 shiftwidth=4
    autocmd FileType python setlocal tabstop=4 shiftwidth=4
    autocmd FileType cs setlocal shiftwidth=4 softtabstop=-1 tabstop=8
    autocmd FileType indent plugin on
    autocmd FileType go setlocal tabstop=4 shiftwidth=4
    autocmd FileType json setlocal tabstop=2 shiftwidth=2
    " enable below if you want to use prettier
    "autocmd BufWritePost *.ts :silent! exec "!prettier --loglevel silent --write " . expand('%:p') | :silent! exec "e" | :silent! exec "!ctags -R &" | redraw!
    autocmd BufWritePost *.ts redraw!
    "autocmd BufWritePost *.ts :silent! exec "!ctags -R &" | redraw!
    autocmd BufRead *.ts :setlocal tags=./tags;/
    autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd guibg=gray ctermbg=17 | :hi IndentGuidesEven guibg=gray ctermbg=17
    "autocmd VimEnter * :Vexplore
endif

nnoremap <C-LeftMouse> :ALEGoToDefinition<CR>
nnoremap <C-I> :ALEGoToDefinition<CR>
