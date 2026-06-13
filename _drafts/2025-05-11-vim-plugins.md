---
title: A Comprehensive Guide to make and Makefiles
date: 2025-05-11
categories: [dev, vim]
tags: [vim plugins]
layout: single
permalink: /notes/2025/05/vim-plugins/
author_profile: true
read_time: true
comments: true
share: true
related: true
---

# 📝 Vim Plugin Development

## Structure of a Vim Plugin


```
my_plugin/
├── plugin/
│   └── main.vim          # Main plugin code
├── autoload/
│   └── myplugin.vim      # Deferred loading
├── doc/
│   └── myplugin.txt      # Help docs
├── ftplugin/
│   └── python.vim        # Filetype-specific
└── README.md
```

Within each `.vim` file, your plugin has access to three methods for processing information:
- Using Vim script, interpreted directly in Vim
- Using an external interpreter, like Python, Ruby, etc.
- Using the output from another command-line program


You are free to mix and match them as your plugin needs. Usually, it is best to choose an approach that most efficiently accomplishes your plugin’s goals.

`autoload/myplugin.vim` is a file that gets loaded whenever one of yhour plugin's commands get called.

Write this code to `myplugin.vim` in `plugin` directory.

```
if exists("g:loaded_myplugin")
    finish
endif
let g:loaded_lazy-verilog= 1
```
