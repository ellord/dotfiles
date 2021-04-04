"
"   ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗ ██████╗
"   ██║   ██║██║████╗ ████║██╔══██╗██╔════╝██╔════╝
"   ██║   ██║██║██╔████╔██║██████╔╝██║     ██║  ███╗
"   ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║     ██║   ██║
"    ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗╚██████╔╝
"     ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝
"
"   Customizable VimRC Generator: https://vimrc.org
"   Configuration Generated on: August 07, 2018
" ---------------------------------------------------
set nocompatible
" Variables                      {{{
" --> define os specific variables
let g:is_gui     = has('gui_running')
let g:is_mac     = has('mac') || has('macunix') || has('gui_macvim')
let g:is_nix     = has('unix') && !has('macunix') && !has("win32unix")
let g:is_macvim  = g:is_mac && g:is_gui && has('gui_macvim')
let g:is_ubuntu  = g:is_nix && system("uname -a") =~ "Ubuntu"
let g:is_windows = has('win16') || has('win32') || has('win64')

" --> define other relevant variables
let g:is_posix   = 1 " enable better bash syntax highlighting

" --> define what kind of VIM UI we are working with?
if g:is_macvim                | let g:ui_type = "MVIM"
elseif g:is_gui               | let g:ui_type = "GUI"
elseif exists("$TMUX")        | let g:ui_type = "TMUX"
elseif exists("$COLORTERM")   | let g:ui_type = "CTERM"
elseif exists("$TERM")        | let g:ui_type = "TERM"
else | let g:ui_type = "????" | endif

" }}}

" Plugin Manager                 {{{
" --> auto-install a plugin manager for VIM, if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" --> define helper function to conditionally require plugins
"     used as:
"       Plug 'benekastah/neomake', Cond(has('nvim'), { 'on': 'Neomake' })
function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

" --> define function to install a plugin from a Gist URL
function! PlugFromGist(id, name)
  Plug 'https://gist.github.com/'.id.'.git',
    \ { 'as': name, 'do': 'mkdir -p plugin; cp -f *.vim plugin/' }
endfunction

" }}}

" --> Personalize: allows customizations via a local configuration
if filereadable(expand("~/.vimrc.pre")) | source ~/.vimrc.pre | endif
call plug#begin(expand("~/.vim/bundle"))
" Editor                         {{{
" --> use soft tabs (with spaces) over hard tabs
set tabstop=2                   " a tab is two spaces
set softtabstop=2               " when <BS>, pretend tab is removed, even if spaces
set expandtab                   " expand tabs, by default
set nojoinspaces                " prevents two spaces after punctuation on join

autocmd Filetype go setlocal tabstop=2

" --> provide movement around surroundings of text object
Plug 'tpope/vim-surround'

" }}}

" Terminal                       {{{
" --> set appropriate terminal colors for the terminal
if &t_Co > 2 && &t_Co < 16
  set t_Co =16
elseif &t_Co > 16
  set t_Co =256
endif

" }}}

" Colorschemes                   {{{
" --> provide more colorschemes for the editor
Plug 'ciaranm/inkpot'
Plug 'DAddYE/soda.vim'
Plug 'Pychimp/vim-luna'
Plug 'fugalh/desert.vim'
Plug 'nanotech/jellybeans.vim'
Plug 'jnurmine/Zenburn'
Plug 'minofare/VIM-Railscasts-Color-Theme'
Plug 'flazz/vim-colorschemes'
" Plug 'wombat256.vim'
" Plug 'cstrahan/grb256'
" Plug 'chriskempson/base16-vim'
Plug 'chriskempson/vim-tomorrow-theme'
" Plug 'daylerees/colour-schemes', { 'rtp': 'vim-themes/' }

" }}}

" Line Numbers                   {{{
" --> enable line numbers with maximum 4 gutter columns
set number
set numberwidth=4

" --> provide toggle key for displaying relative line numbers (RLN)
nnoremap <leader>trn :set relativenumber!<cr>

" --> use absolute line numbers everywhere
augroup relative_line_numbers
  au!
  autocmd FocusLost,BufLeave,InsertEnter   * if &number | :setl norelativenumber | endif
  autocmd FocusGained,BufEnter,InsertLeave * if &number | :setl relativenumber   | endif
augroup end

" }}}

" Sane Defaults                  {{{
" --> watch for file & directory changes, but don't auto-write files
set autoread                      " watch for file changes
set noautochdir                   " do not auto change the working directory
set noautowrite                   " do not auto write file when moving away from it
set nofsync                       " allows OS to decide when to flush to disk

" --> scroll text automatically when cursor is near edges
set scrolloff=7                 " keep lines off edges of the screen when scrolling
set sidescroll=1                " brings characters in view when side scrolling
set sidescrolloff=15            " start side-scrolling when n chars are left
" set scrolljump=5                " lines to scroll when cursor leaves screen

" --> advice VIM to work with UTF-8 encodings by default
scriptencoding utf-8
set encoding=utf-8 nobomb " BOM often causes trouble
set termencoding=utf-8
set fileencodings=utf-8,gb2312,gb18030,gbk,ucs-bom,cp936,latin1

" --> disables file backups via VIM (use versioning, instead!)
set nobackup                      " do not keep backup files - it's 70's style cluttering
set nowritebackup                 " do not make a write backup
set noswapfile                    " do not write annoying intermediate swap files
set directory=~/.vim/tmp/swaps,/tmp    " store swap files in one of these directories (in case swapfile is ever turned on)

" --> disable annoying VIM error bells :P
set noerrorbells                  " don't beep
set visualbell t_vb=              " don't beep, remove visual bell char

" --> set timeout on key combinations, e.g. mappings & key codes
set timeout                     " timeout on :mappings and key codes
set timeoutlen=600              " timeout duration should be sufficient to type the mapping
set ttimeoutlen=50              " timeout duration should be small for keycodes
                                " try pressing 'O' in normal mode in terminal editor

" --> dont update display when executing macros, etc.
set lazyredraw

" --> always show line numbers
set number

" --> (security) reject modelines altogether
set nomodeline

" --> (security) do not allow per-directory vim configurations
set noexrc
set secure

" --> (security) use a stronger encryption method
if exists("&cryptmethod") | set cryptmethod=blowfish | endif

" --> enable '%' key to match much more than braces.
runtime macros/matchit.vim

" }}}

" Basic Colors                   {{{
" --> enable TrueColor support
if &term =~# '^screen'
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" --> provide some beautiful colorschemes for the editor
"  Run :PlugInstall after adding a plugin to install
Plug 'dracula/vim'
Plug 'morhetz/gruvbox'
Plug 'trevordmiller/nova-vim'
Plug '29decibel/codeschool-vim-theme'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'altercation/vim-colors-solarized'
Plug 'yuezk/vim-js'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

if has('nvim') || has('patch-8.0.902')
  Plug 'mhinz/vim-signify'
else
  Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
endif

" }}}

call plug#end()
colorscheme Tomorrow-Night-Eighties
let g:airline_theme='nova'

" Coc config
let g:coc_global_extensions = ['coc-emmet', 'coc-eslint', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier', 'coc-tsserver']
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" NERDTree config
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''
" Automaticaly close nvim if NERDTree is only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Toggle
nnoremap <silent> <C-b> :NERDTreeToggle<CR>

" Fuzzy finder
nnoremap <C-p> :FZF<CR>
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit'
  \}
let $FZF_DEFAULT_COMMAND = 'ag -g ""'

" Pane switching
" use alt+hjkl to move between split/vsplit panels
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" --> Personalize: allows customizations via a local configuration
if filereadable(expand("~/.vimrc.local")) | source ~/.vimrc.local | endif
