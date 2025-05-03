---
title: About make and makefiles
date: 2025-05-02
categories: [dev, cpp]
tags: [make]
---

This post explains about the **make command and Makefiles**

-----------------------------------

### Makefiles

`Makefile` usually resides in the same directory as the other sources files. It tells how your program is constructed to the `make` command.

Using the `make` command together with a `Makefile` offers a highly effective way to manage and organize project builds.

-----------------------------------

### Installation

In Ubuntu OS, `make` can be installed by:

```shell
sudo apt install make
```

-----------------------------------

### How to write Makefiles

A makefile is made up of a series of dependencies and rules. Each dependency includes a target (the file that needs to be generated) and one or more source files that it relies on. The rules specify the steps required to produce the target from its dependent files. In most cases, the target refers to a single executable file.

The makefile is processed by the make command, which identifies the target file or files to build. It then checks the timestamps of the source files to determine which rules must be executed to generate the desired target. Frequently, several intermediate targets must be created before the final one is built. The make command uses the makefile to figure out the proper build order and the appropriate sequence of rules to apply.

#### Tabs vs spaces

In order for `make` to distinguish between a recipe and lines that are not part of a recipe, it relies on the presence of `TAB` characters.
Any line that starts with a `TAB` is interpreted as part of a recipe—this means it's treated as a shell command and passed to the shell for execution. 
Conversely, lines that do not start with a `TAB` are not considered part of a recipe; instead, they are interpreted as Makefile-syntax and not executed by the shell.

#### Dependencies

```Makefile
//The dependency list of the above program is as follows.
myProgram: main.o 2.o 3.o
main.o: main.c a.h
2.o: 2.c a.h b.h
3.o: 3.c a.h b.h c.h
```

This `Makefile` says that `myProgram` is dependent on `main.o`, `2.o` and `3.o`.
`main.o` is dependent on `main.c` and `a.h`.

#### Target

```Makefile
myProgram: main.o 2.o 3.o
  gcc -o myProgram main.o 2.o 3.o
main.o: main.c a.h
  gcc -c main.c
2.o: 2.c a.h b.h
  gcc -c 2.c
3.o: 3.c b.h c.h
  gcc -c 3.c
```
Note that every `gcc` command is indented by `TAB`s.  
This `Makefile` tells which command needs to be run to generate each file.  
`make` command reads this `Makefile` and run `gcc -c 3.c` to generate `3.o` if needed.  

#### Macros



-----------------------------------

### Options to make

| Options | Description                                                                                                |
| :-:     | :-                                                                                                         |
|`-k`     | keep going even when error is found.                                                                       |
|`-n`     | prints out what it would have done whithout actually doing it.                                             |
|`-f`     | specify which file to use as its makefile. default is `makefile` or `Makefile` in the current directory.   |



