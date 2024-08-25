call plug#begin()

Plug 'tpope/vim-sensible'
Plug 'HerringtonDarkholme/yats.vim'  " TypeScript syntax
Plug 'leafgarland/typescript-vim'    " TypeScript support
Plug 'peitalin/vim-jsx-typescript'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }

call plug#end()

silent! colorscheme catppuccin_mocha

" set filetypes as typescriptreact
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescriptreact

" Ensure transparency
augroup user_colors
  autocmd!
  autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
  autocmd ColorScheme * highlight NonText ctermbg=NONE guibg=NONE
  autocmd ColorScheme * highlight LineNr ctermbg=NONE guibg=NONE
  autocmd ColorScheme * highlight Folded ctermbg=NONE guibg=NONE
  autocmd ColorScheme * highlight SignColumn ctermbg=NONE guibg=NONE
augroup END

" Apply transparency immediately
highlight Normal ctermbg=NONE guibg=NONE
highlight NonText ctermbg=NONE guibg=NONE
highlight LineNr ctermbg=NONE guibg=NONE
highlight Folded ctermbg=NONE guibg=NONE
highlight SignColumn ctermbg=NONE guibg=NONE

set re=0

syntax on

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set number
set relativenumber

set lazyredraw

set nobackup
set nowritebackup
set noswapfile

scriptencoding utf-8
set encoding=utf-8 nobomb
set termencoding=utf-8
set fileencodings=utf-8,gb2312,gb18030,gbk,ucs-bom,cp936,latin1
