---
title: Setting up nvim-lspconfig for your project.
date: 2025-05-26
categories: [dev, vim]
tags: [vim]
layout: single
permalink: /notes/2025/05/nvim-lspconfig/
author_profile: true
read_time: true
comments: true
share: true
related: true
---

When developing C or C++ projects with Neovim, one of the most powerful tools to get IDE-like features (code completion, diagnostics, go-to-definition) is using `nvim-lspconfig`, a plugin that configures the Language Server Protocol (LSP) client for Neovim.

---

### 🛠️ What is nvim-lspconfig?

`nvim-lspconfig` is a Neovim plugin that simplifies setting up language servers, such as clangd for C/C++ or pyright for Python. It provides ready-to-use configurations so you can quickly enable IDE-like features like auto-completion, diagnostics, go-to-definition, and symbol renaming inside Neovim.

---

### ⚡ How to Install and Setup nvim-lspconfig

You can install nvim-lspconfig easily with your favorite plugin manager. For example, using vim-plug:
In your `init.vim` or `init.lua` for Neovim,

```
call plug#begin('~/.local/share/nvim/plugged')
Plug 'neovim/nvim-lspconfig'
call plug#end()
```

After installing, add a minimal setup for clangd in your init.lua or Lua config file:

```lua
require('lspconfig').clangd.setup {
  cmd = { "clangd" },
}
```

Then restart Neovim and run `:PlugInstall` (if using `vim-plug`). Your C/C++ files will have LSP support enabled!

However, if your project uses a `Makefile`(especially on Windows with MSVC), you might run into frustrating errors from `clangd` — like unknown types (`LPCWSTR`, `DWORD64`) or missing includes — even though your project compiles fine.

Why Does This Happen?
`clangd` (the language server for C/C++) needs to know how your code is built, including:

- Include paths (`-I` or `/I` flags)
- Macro definitions (`-D` flags)
- Compiler flags

If it doesn’t have this info, it guesses defaults and can’t find Windows SDK headers or project-specific macros. This causes spurious errors in your editor.

--- 

### 🤔 Why Does clangd Need compile_commands.json?

`clangd` powers the C/C++ LSP experience by parsing your source code and providing intelligent feedback. But to do this correctly, it needs to understand how your code is compiled — which headers are included, what macros are defined, and what flags are used.

For projects using `CMake`, this information is automatically generated. But for projects using plain `Makefiles`, `clangd` often lacks this context, leading to false errors like unknown types (`LPCWSTR`, `DWORD64`) or missing system includes.
The best way to provide clangd with this build information is via a file called `compile_commands.json`. This JSON file lists every compilation command used for every source file in your project.

When clangd can locate `compile_commands.json`, it uses the exact compiler flags and include paths, so the LSP errors vanish.

---

### 🐻 Generating compile_commands.json with bear

Unlike `CMake`, which can generate this file natively, plain Makefiles don’t provide it automatically. This is where bear comes in.  Build EAR(`bear`) wraps your build process and records all compiler invocations. It then produces `compile_commands.json` for you.

Install bear on your system:

```bash
sudo apt install bear
```

Run your build through bear:

```bash
bear -- make
```

This creates `compile_commands.json` in your project root.

---

### 🔍 Where Does clangd Look for compile_commands.json?

`clangd` locates `compile_commands.json` by searching upward from the file’s directory you’re editing in Neovim.

Take a look at this example:

📁 Typical directory structure example:
```
my_project/
├── compile_commands.json
├── src/
│   ├── main.cpp
│   └── utils.cpp
└── include/
    └── utils.h
```
If you open up `src/main.cpp` in Neovim, `clangd` starts looking inside `src/` for `compile_commands.json`.

Not finding it there, it goes up to `my_project` and finds it.


However, if `compile_commands.json` is in a subdirectory like `build/`, for example:
```
my_project/
├── src/
│   ├── main.cpp
│   └── utils.cpp
├── include/
│   └── utils.h
└── build/
    └── compile_commands.json  (sometimes generated here)
```

In this case, `clangd` will not be able to find `compile_commands.json` automatically.  

In this case, you can tell `clangd` where to find it by `--compile-commands-dir` option.  

Configure clangd with `--compile-commands-dir=build` in your nvim-lspconfig setup:  

```lua
require('lspconfig').clangd.setup {
  cmd = { "clangd", "--compile-commands-dir=/path"},  -- Uses compile_commands.json automatically
}
```

With `compile_commands.json` in place, your LSP will accurately reflect your project’s actual build environment, eliminating errors caused by missing headers or macros.

---

### 📚 References
[1] [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)  
[2] [bear - Build EAR](https://github.com/rizsotto/Bear)  
[3] [Neovim GitHub repository](https://github.com/neovim/neovim)  
