source ~/.config/nvim/plugins.vim

" sets terminal to support 24-bit RGB colors rather than 16 colors.
" terminal foreground color(text color).
let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
" terminal background color.
let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"

lua require('init')

set number
set history=1000
set mouse=a
set autoread
set ruler
set hlsearch
set incsearch
set showmatch
set encoding=utf-8
set fileencodings=utf-8,cp949
colorscheme challenger_deep
syntax on
filetype on
set shiftwidth=4
set expandtab
set tabstop=4
set cindent

" clipboard settings
let g:clipboard = {
    \   'name': 'WslClipboard',
    \   'copy': {
    \      '+': 'clip.exe',
    \      '*': 'clip.exe',
    \    },
    \   'paste': {
    \      '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    \      '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    \   },
    \   'cache_enabled': 0,
    \ }

" some useful shortcuts
vnoremap <C-c> "+y
nnoremap <C-v> "+p
nnoremap <C-m> <Plug>MarkdownPreview
nnoremap <C-t> :NvimTreeOpen<CR>
