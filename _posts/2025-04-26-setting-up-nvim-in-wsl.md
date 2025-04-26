---
title: Setting up Neovim in WSL
date: 2025-04-26
categories: [dev, vim]
tags: [nvim, wsl]
---

This post explains how to setup neovim in WSL2.  


-----------------------------------

## WSL2

[WSL2](https://learn.microsoft.com/en-us/windows/wsl/about) (Windows Subsystem for Linux 2) is a compatibility layer for running Linux binaries natively on Windows. It is an upgrade over the original WSL and provides a full Linux kernel running inside a lightweight virtual machine (VM) rather than using a translation layer. This means it offers better performance, compatibility, and support for more Linux applications, including those that require specific kernel features like Docker.


-----------------------------------

## neovim

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

- Download (package)[https://downgit.github.io/#/home?url=https://github.com/hxxdev/hxxdev.github.io/tree/main/assets/posts/setting_up_nvim/nvim]

The packages include:

- [vim-plug](https://github.com/junegunn/vim-plug)
- [nvim-notify](https://github.com/rcarriga/nvim-notify)
- [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)
- [nvim-noice](https://github.com/folke/noice.nvim)
- [nvim-nui](https://github.com/MunifTanjim/nui.nvim)
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [image.nvim](https://github.com/3rd/image.nvim)

- Move `vim-plug` into runtime autoload path.

```shell
mv -r vim-plug /home/linuxbrew/.linuxbrew/Cellar/neovim/0.11.0/share/nvim/runtime/autoload
```

- Copy downloaded package into `~/.config/`.

```shell
cp -r nvim ~/.config
```

-----------------------------------

## Setting up markdown-preview
- Install npm. 

```shell
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
command -v nvm
```

- Install the current stable LTS release of Node.js.

```shell
nvm install --lts
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

```nvim
mdkp#util#install
```

-  Preview markdown files.

```nvim
:MarkdownPreview
```

