---
title: Setting up Neovim
date: 2025-04-26
categories: [dev, vim]
tags: [nvim, wsl]
---

This post explains how to install and setup neovim.  


-----------------------------------

## Neovim

[Neovim](https://neovim.io/) (nvim) is an extensible, open-source text editor that is a refactor and improvement of Vim. It aims to enhance the usability and feature set of Vim, while maintaining compatibility with Vim's commands and configuration.


-----------------------------------

## How to install

- Install [Homebrew](https://docs.brew.sh/).

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

- Install neovim.

```
brew install neovim
```

- Download [package](https://github.com/hxxdev/hxxdev.github.io/tree/main/assets/posts/setting_up_nvim/nvim)

The packages include:

- [vim-plug](https://github.com/junegunn/vim-plug)
- [nvim-notify](https://github.com/rcarriga/nvim-notify)
- [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)
- [nvim-noice](https://github.com/folke/noice.nvim)
- [nvim-nui](https://github.com/MunifTanjim/nui.nvim)
- [nvim-tree](https://github.com/nvim-tree/nvim-tree.lua)
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [image.nvim](https://github.com/3rd/image.nvim)
- [vim-gutentags](https://github.com/ludovicchabant/vim-gutentags)

Move `vim-plug` into runtime autoload path.

```shell
mv -r vim-plug /home/linuxbrew/.linuxbrew/Cellar/neovim/0.11.0/share/nvim/runtime/autoload
```

- Copy downloaded package into `~/.config/`.

```shell
cp -r nvim ~/.config
```

-----------------------------------

## Setting up markdown-preview

- Install ctags.  

```shell
sudo apt-get install -y exuberant-ctags
```

- Write `~/.ctags`.

```
--recurse=yes
--exclude=.git
--exclude=BUILD
--exclude=.svn
--exclude=*.js
--exclude=vendor/*
--exclude=node_modules/*
--exclude=db/*
--exclude=log/*
--exclude=\*.log
--exclude=\*.min.\*
--exclude=\*.swp
--exclude=\*.bak
--exclude=\*.pyc
--exclude=\*.class
--exclude=\*.sln
--exclude=\*.csproj
--exclude=\*.csproj.user
--exclude=\*.cache
--exclude=\*.dll
--exclude=\*.pdb
--exclude=\*.obj
--exclude=\*.exe
``` 

- Validate Node.js installation.

```shell
node --version
```

- Refresh session

```shell
exec $SHELL
```

- Install packages to resolve dependancy:

```shell
sudo npm install tslib
npm install neovim
sudo npm install neovim
sudo npm install @chemzqm/neovim
sudo npm install log4js
sudo npm install socket.io
sudo npm install msgpack-lite
```

- Run this in nvim:

```
mdkp#util#install
```

-  Preview markdown files.

```
:MarkdownPreview
```

-----------------------------------

## Setting up ctags

- Install ctags

```shell
brew install universal-ctags
```

- gu

```shell
nvm install --lts

-----------------------------------

## Setting up autocompletion
