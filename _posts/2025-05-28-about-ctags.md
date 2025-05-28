---
title: ctags configuration, options, and language support
date: 2025-05-28
categories: [dev, dev_tools]
tags: [ctags]
---
`ctags` is a tool used to generate an index (or "tags" file) of language objects found in source files. These tags can be used by editors like Vim to navigate code more efficiently. This post will go through a detailed explanation of how to use `ctags`, and some common usages.

---

### Difference Between Universal Ctags and Exuberant Ctags

First, let's go through some history lesson.  
There are two types of `ctags`: `excuberant-ctags` and `universal-ctags`.

- **Exuberant Ctags**  
  - The older and widely used version of ctags for many years.  
  - Supports many popular languages but development has mostly stopped since around 2010.  
  - Limited support for newer languages and fewer customization features.  
  - Typically comes pre-installed on many Unix-like systems.

- **Universal Ctags**  
  - A modern fork and continuation of Exuberant Ctags, actively maintained and improved.  
  - Supports a much wider range of languages (including many modern languages).  
  - Better extensibility and modular design.  
  - Supports `.ctags.d` configuration directory and more advanced features like enhanced parsing.  
  - Regularly updated with bug fixes and new features.  
  - Recommended if you need support for newer languages (like SystemVerilog) or better customization.

In summary, Universal Ctags is the actively developed successor to Exuberant Ctags with more features and broader language support.  
You can check out which one you have by `ctags --version`.

---

### Basic Usage
To generate tags for all source files in a directory recursively:
```
ctags -R
```
This creates a `tags` file in the current directory containing tag definitions for all recognized files.

To generate tags for specific files or directories:
```
ctags file1.c file2.cpp
ctags -R src/ include/
```

---

### Useful Options

| Option                        | Description                                                                 | Example Usage                                         |
|------------------------------|-----------------------------------------------------------------------------|-------------------------------------------------------|
| `-R`                         | Recursively descend into directories.                                      | `ctags -R`                                            |
| `-f <filename>`              | Write the tags to a specific file.                                          | `ctags -f mytags -R .`                                |
| `--languages=<list>`         | Restrict to specific languages.                                             | `ctags --languages=C,C++ -R`                          |
| `--exclude=<pattern>`        | Exclude files or directories.                                               | `ctags --exclude=.git --exclude=build -R`            |
| `--fields=+<flags>`          | Add extra fields of information to tag entries.                             | `ctags --fields=+nks`                                 |
| `--kinds-<language>=<kinds>` | Restrict or specify kinds of tags per language.                             | `ctags --kinds-C=+p`                                  |
| `--langmap=<lang>:<exts>`    | Map file extensions to specific languages.                                  | `ctags --langmap=C:.abc`                              |

#### Common `--fields` Flags

| Flag | Description                        |
|------|------------------------------------|
| `n`  | Include line numbers of tag definitions. |
| `k`  | Include kind of tag (e.g., function, variable, etc.). |
| `s`  | Include scope (e.g., class or function name for nested items). |
| `a`  | Include access (public/private/protected). |
| `i`  | Include inheritance information. |
| `S`  | Include signature (parameter list for functions). |

Example:
```
ctags --fields=+nkSa -R
```

#### About `--kinds`

The `--kinds-<language>=<kinds>` option controls which kinds of symbols (functions, variables, macros, classes, etc.) are indexed for a given language. You can:

- Add kinds using `+`, remove using `-`, or set them explicitly.
- The available kinds depend on the language. To list them:

```
>_ ctags --list-kinds=<language>
d  macro definitions
e  enumerators (values inside an enumeration)
f  function definitions
g  enumeration names
h  included header files
l  local variables [off]
m  struct, and union members
p  function prototypes [off]
s  structure names
t  typedefs
u  union names
v  variable definitions
x  external and forward variable declarations [off]
z  function parameters inside function or prototype definitions [off]
L  goto labels [off]
D  parameters inside macro definitions [off]
```

Example:
```
ctags --kinds-C=+p
```
This will add function prototypes (`p`) to tags.

---

### Reading Custom File Extensions as Specific Filetypes

To tell `ctags` to treat `.abc` files as C files, you can use:
```
ctags --langmap=C:.abc -R
```
This maps `.abc` to the `C` language.

You can also combine mappings:
```
ctags --langmap=C:.c.h.abc --languages=C
```

---

### About `.ctags` and `.ctags.d`

- **`.ctags` file:**  
  This is a plain text configuration file that can be placed in your home directory (`~/.ctags`) or in the current working directory. It contains `ctags` command-line options, one per line, that are applied automatically whenever you run `ctags` in that directory (or from that directory's context). It is useful for setting global or project-specific defaults.

- **`.ctags.d` directory:**  
  Used by Universal Ctags for modular configuration. Instead of a single `.ctags` file, you can organize configuration options into multiple `.conf` files inside a `.ctags.d` directory. This directory can exist in your home directory (`~/.ctags.d/`) or inside a project directory. Each `.conf` file contains `ctags` options, one per line.

Here’s an example showing how a `.ctags.d` folder might be organized in your home directory:

```
~/
├── .ctags
├── .ctags.d/
│   ├── c.conf
│   ├── cpp.conf
│   ├── python.conf
│   └── custom/
│       ├── embedded.conf
│       └── experimental.conf
```

- `.ctags` — A general configuration file that may contain settings applied across all languages.
- `.ctags.d/` — Modular configuration directory. Each `.conf` file is read and applied when `ctags` is executed.
  - `c.conf` — Contains options specific to C language.
  - `cpp.conf` — Contains options specific to C++.
  - `python.conf` — Contains options specific to Python.
  - `custom/` — A subfolder used to group custom or experimental configs.
    - `embedded.conf` — Might include settings for embedded C.
    - `experimental.conf` — Might include test settings for development.

**How it works:**  
When you run `ctags`, Universal Ctags will automatically load options from a `.ctags` file if present, and from all `.conf` files inside any `.ctags.d` directory found in the current directory or any of its parent directories. This makes configuration hierarchical and modular, allowing you to override or extend options based on your location in the filesystem.

**Example:**

If you have this config:

**~/.ctags.d/c.conf**
```
--languages=C
--kinds-C=+p
--fields=+iaS
--langmap=C:.abc
```

These settings will always be read, but only affect files processed as C due to the `--languages` option.

For example, if your project contains:
```
main.c
utils.abc
script.py
```

And you run:
```
ctags -R
```

- `main.c` and `utils.abc` (because of the langmap) will be affected by the options in `c.conf`.
- `script.py` will be unaffected unless there's a separate `python.conf` with Python-specific options.

**This modular structure helps you organize per-language configurations while keeping them all active and automatically applied.**

---

### How to Install New Languages Not Listed in `--list-languages`

If you find that a language (e.g., SystemVerilog) is missing from the list when running:
```
ctags --list-languages
```

it means your current `ctags` build does not include support for that language.

To add new language support:

1. **Switch to Universal Ctags:**  
   Universal Ctags has broader and more up-to-date language support compared to Exuberant Ctags.

2. **Build Universal Ctags from Source:**  
   Clone and build Universal Ctags which often includes more languages:
   ```
   git clone https://github.com/universal-ctags/ctags.git
   cd ctags
   ./autogen.sh
   ./configure
   make
   sudo make install
   ```

3. **Check Again:**  
   After installing, verify available languages:
   ```
   ctags --list-languages
   ```

4. **Custom Parsers or Extensions:**  
   If your desired language is still not supported, you may need to:
   - Write or obtain a parser plugin (for Universal Ctags).  
   - Use regex-based custom language definitions (supported in Universal Ctags).  
   - Contribute or request support from the community.

These steps will help you extend `ctags` to recognize and index code in new or uncommon languages.


---

## References

[1] [Universal Ctags GitHub](https://github.com/universal-ctags/ctags)

[2] [Ctags document](https://docs.ctags.io)
