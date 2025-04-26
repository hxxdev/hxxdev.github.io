source ~/.config/nvim/plugins.vim

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
colorscheme vim
syntax on
filetype on
set shiftwidth=4
set expandtab
set tabstop=4
set cindent
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

vnoremap <C-c> "+y
nnoremap <C-v> "+p
nnoremap <C-m> <Plug>MarkdownPreview
nnoremap <C-e> :NvimTreeOpen<CR>
