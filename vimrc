"set nocompatible               " be iMproved
"filetype off                   " required!
set nocompatible | filetype indent plugin on | syn on

" Install vim-plug if it isn't installed and call plug#begin() out of box
function! s:download_vim_plug()
  if !empty(&rtp)
    let vimfiles = split(&rtp, ',')[0]
  else
    echohl ErrorMsg
    echomsg 'Unable to determine runtime path for Vim.'
    echohl NONE
  endif
  if empty(glob(vimfiles . '/autoload/plug.vim'))
    let plug_url =
          \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    if executable('curl')
      let downloader = '!curl -fLo '
    elseif executable('wget')
      let downloader = '!wget -O '
    else
      echohl ErrorMsg
      echomsg 'Missing curl or wget executable'
      echohl NONE
    endif
    if !isdirectory(vimfiles . '/autoload')
      call mkdir(vimfiles . '/autoload', 'p')
    endif
    if has('win32')
      silent execute downloader . vimfiles . '\\autoload\\plug.vim ' . plug_url
    else
      silent execute downloader . vimfiles . '/autoload/plug.vim ' . plug_url
    endif

    " Install plugins at first
    autocmd VimEnter * PlugInstall | quit
  endif
  call plug#begin(vimfiles . '/plugged')
endfunction

call s:download_vim_plug()

Plug 'vim-scripts/a.vim'
Plug 'majutsushi/tagbar'
Plug 'easymotion/vim-easymotion'
Plug 'markonm/traces.vim'
Plug 'tpope/vim-endwise'
Plug 'sheerun/vim-polyglot'
Plug 'w0rp/ale'
Plug 'vim-scripts/hgrev'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-rails'
Plug 'tomtom/tcomment_vim'
Plug 'sukima/xmledit'
Plug 'tpope/vim-fugitive'
Plug 'khwon/gitignore'
Plug 'junegunn/gv.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'khwon/Vim-Tomorrow-Theme'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-easytags'
Plug 'vim-scripts/indenthtml.vim'
Plug 'pangloss/vim-javascript'
Plug 'khwon/cscope_maps.vim'
Plug 'vim-ruby/vim-ruby'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-dispatch'
Plug 'khwon/vim-conflicted'
" Provide CamelCase motion through words
Plug 'bkad/CamelCaseMotion'
" ANSI escape
Plug 'powerman/vim-plugin-AnsiEsc', { 'for': 'railslog' }

Plug 'tpope/vim-vinegar'

" assembly indentation
Plug 'khwon/asm.vim'

Plug 'Valloric/YouCompleteMe'
" Echo preview window in command line
Plug 'khwon/echodoc.vim'

Plug 'junegunn/rainbow_parentheses.vim'

Plug 'metakirby5/codi.vim'


if has('mac') || has('macunix')
  " Add plist editing support to Vim
  Plug 'darfink/vim-plist'
  " Assume fzf is installed in osx
  Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
else
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
  Plug 'junegunn/fzf.vim'
endif

call plug#end()
"vim-eunuch AutoComplPopup pythoncomplete rubycomplete

set bg=dark " background를 dark로 설정한다
syntax enable
set ai "set autoindent
set ts=2
set sw=2 " tab 관련 설정
set et
set nu " show line number
set nobackup "do not make backup files
set title " windows title을 현재 편집중인 파일이름으로 한다.
set incsearch "incremental search
set hlsearch "search를 할때 highlight를 해준다.
set smartcase "소문자로 검색시 대소문자 무시, 대문자로 검색시 대문자만 검색
filet plugin indent on " filetype에 따른 plugin, indetation을 켠다.
set fencs=ucs-bom,utf-8,cp949 "try this encodings when open files
set showmatch "match brakets
set autowrite "auto save when :make or :next
set foldmethod=syntax " syntax에 따라 folding을 한다.
set foldlevel=9999999 "open all fold
set km-=stopsel " ctrl+f & ctrl+b don't stop visual mode
set showcmd
set backspace=2
"set cscopetag "use cscope for tag commands
set dy+=uhex "show unprintable characters as a hex number
"set transparency = 3 "macvim only
set clipboard=unnamed "share clipboard with register
set laststatus=2
set scrolloff=3  " 커서의 위아래로 항상 세줄의 여유가 있게끔.
set completeopt=menu,menuone,longest " do not show preview window on omnicompletion
command! W w " :W로 저장

au BufRead,BufNewFile *.cc set filetype=cpp "*.cc를 c++로 인식
if has("win32")
       set makeprg=nmake "windows 환경에선 make대신 nmake사용
endif

map <C-j> :cn<CR> " Ctrl + j로 다음 에러를 찾아간다.
imap <C-j> <esc>:cn<CR>
map <C-k> :cp<CR>
imap <C-k> <esc>:cp<CR> " Ctrl + k로 이전 에러를 찾아간다.

" man page settings
autocmd FileType ruby set keywordprg=ri
autocmd FileType c,cpp set keywordprg=man

if has("gui_running")
	set go=gmr
	colorscheme slate
	hi Comment guifg=grey60
	set cursorline "highlight current line
	autocmd WinEnter * setlocal cursorline
	autocmd WinLeave * setlocal nocursorline
endif



" from github.com/astrails/dotvim
" ignore these files when completing names and in
" explorer
set wildignore=.svn,CVS,.git,.hg,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,*.pyc

" set wildignore from gitignore
autocmd VimEnter * WildignoreFromGitignore
autocmd VimEnter * WildignoreFromGitignore ~/.gitignore_global

set autowriteall        " Automatically save before commands like :next and :make
set hidden              " enable multiple modified buffers
set history=1000
set autoread            " automatically read file that has been changed on disk and doesn't have changes in vim


" center display after searching
nnoremap n   nzz
nnoremap N   Nzz
nnoremap *   *zz
nnoremap #   #zz
nnoremap g*  g*zz
nnoremap g#  g#z

" show red bg for extra whitespace
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red
au InsertLeave * match ExtraWhitespace /\s\+$/

colorscheme Tomorrow-Night-Eighties

"Reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv

" I can type :help on my own, thanks.
noremap <F1> <Esc>

"Disable paste mode when leaving Insert Mode
au InsertLeave * set nopaste

"highlight the current line of cursor
set cursorline

" Insert only one space after a '.', '?' and '!' with a join command
set nojoinspaces

"---------------- Tagbar ----------------------
" F4 : Switch on/off Tagbar
nnoremap <silent> <F4> :TagbarToggle<CR>
"in console mode
let g:tagbar_left = 1
"------------------------------------------------

" http://stackoverflow.com/questions/6005874/opening-a-window-in-a-horizontal-split-of-a-vertical-split
fun! OpenTagbar()
  if winnr('$')!=1
    only
  endif
  TagbarOpen
  wincmd l
endfun

let open_sidebar=1

"vertical split & show git diff when git commit
autocmd FileType gitcommit DiffGitCached | wincmd L | wincmd p
autocmd FileType gitcommit let open_sidebar=0

if &diff
  "do not open nerdtree and tlist when in diff mode
  let open_sidebar=0
endif
autocmd VimEnter * if (open_sidebar && exists(':TagbarOpen')) | call OpenTagbar()
autocmd bufenter * if (winnr("$") == 1 && bufname("%") == "Tagbar") | q | endif " exit vim if only sidebar remains

" EasyMotion
let g:EasyMotion_leader_key = '<Leader>'
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)
let g:EasyMotion_startofline = 0 " keep cursor column when JK motion

map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

"Disable some warnings on flake8
"let g:syntastic_python_flake8_args='--ignore=E111,E201,E202,E203,E231'
let g:syntastic_python_flake8_args='--select=E101,E112,E113,E721,W601,W602,W603,W604,F401,F402,F404,F811,F812,F821,F822,F823,F831,F841,N801,N802,N803,N804,N805,N806,N811,N812,N813,N814'

"airline configuration
let g:airline_left_sep=''
let g:airline_right_sep=''

" easytags configuration
let g:easytags_async=1
let g:easytags_syntax_keyword = 'always'
let g:easytags_dynamic_files = 1

" ANSI escape for Rails log
autocmd FileType railslog :AnsiEsc

" YouCompleteMe options
let g:ycm_min_num_of_chars_for_completion=10

" rainbow_parentheses
let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]
augroup rainbow_c
  autocmd!
  autocmd FileType c,c++ RainbowParentheses
augroup END

" temporary fix for shift+k in nvim
if has("nvim")
  map K :tab Man <C-R><C-W><CR>
endif

" use homebrew python in neovim
if has("nvim")
  let g:python2_host_prog = '/usr/local/bin/python'
  let g:python3_host_prog = '/usr/local/bin/python3'
endif

" fzf setting
function! s:update_fzf_colors()
  let rules =
  \ { 'fg':      [['Normal',       'fg']],
    \ 'bg':      [['Normal',       'bg']],
    \ 'hl':      [['Comment',      'fg']],
    \ 'fg+':     [['CursorColumn', 'fg'], ['Normal', 'fg']],
    \ 'bg+':     [['CursorColumn', 'bg']],
    \ 'hl+':     [['Statement',    'fg']],
    \ 'info':    [['PreProc',      'fg']],
    \ 'prompt':  [['Conditional',  'fg']],
    \ 'pointer': [['Exception',    'fg']],
    \ 'marker':  [['Keyword',      'fg']],
    \ 'spinner': [['Label',        'fg']],
    \ 'header':  [['Comment',      'fg']] }
  let cols = []
  for [name, pairs] in items(rules)
    for pair in pairs
      let code = synIDattr(synIDtrans(hlID(pair[0])), pair[1])
      if !empty(name) && code > 0
        call add(cols, name.':'.code)
        break
      endif
    endfor
  endfor
  let s:orig_fzf_default_opts = get(s:, 'orig_fzf_default_opts', $FZF_DEFAULT_OPTS)
  let $FZF_DEFAULT_OPTS = s:orig_fzf_default_opts .
        \ empty(cols) ? '' : (' --color='.join(cols, ','))
endfunction

augroup _fzf
  autocmd!
  autocmd VimEnter,ColorScheme * call <sid>update_fzf_colors()
augroup END

nnoremap <C-P> :Files<CR>
nnoremap <C-\><C-P> :GFiles<CR>

if executable('rg')
  command! -bang -nargs=* Rg
        \ call fzf#vim#grep('rg ' .
        \   '--color=always ' .
        \   '--glob "!.git/*" ' .
        \   '--ignore-case ' .
        \   '--line-number ' .
        \   '--column ' .
        \   '--no-heading ' .
        \   '--hidden ' .
        \   '--ignore-file=~/.gitignore_global ' .
        \   '--follow ' .
        \   <q-args>, 1,
        \   fzf#vim#with_preview('right:50%'),
        \   <bang>0)
endif

if executable('fd')
  let $FZF_DEFAULT_COMMAND = 'fd --type f'
endif

" Youcompleteme
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_show_diagnostics_ui = 0 " turn off diag

" ale / clang-tidy
if !empty(glob("/usr/local/opt/llvm/bin/clang-tidy"))
  let g:ale_c_clangtidy_executable = '/usr/local/opt/llvm/bin/clang-tidy'
  let g:ale_c_clangtidy_checks = ['clang-*', 'cert-*', 'google-*', '-cert-err58-cpp']
  let g:ale_cpp_clangtidy_executable = '/usr/local/opt/llvm/bin/clang-tidy'
  let g:ale_cpp_clangtidy_checks = ['clang-*', 'cert-*', 'google-*', '-cert-err58-cpp']
endif

let g:ale_linters = {
      \ 'c': ['clangtidy', 'cppcheck'],
      \ 'cpp': ['clangtidy', 'cppcheck']
      \}

" echodoc.vim
let g:echodoc#enable_at_startup = 1
set noshowmode

