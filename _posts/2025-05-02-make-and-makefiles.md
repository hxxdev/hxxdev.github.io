---
title: A Comprehensive Guide to make and Makefiles
date: 2025-05-02
categories: [dev, cpp]
tags: [make]
---

This post explains the **make command and Makefiles**

-----------------------------------

### Makefiles

A `Makefile` usually resides in the same directory as the other source files. It tells how your program is constructed to the `make` command.

Using the `make` command together with a `Makefile` offers a highly effective way to manage and organize project builds.

-----------------------------------

### Installation

In Ubuntu OS, `make` can be installed by:

```shell
sudo apt install make
```

-----------------------------------

### How to write Makefiles

A `Makefile` is made up of a series of dependencies and rules. Each dependency includes a target (the file that needs to be generated) and one or more source files that it relies on. The rules specify the steps required to produce the target from its dependent files. In most cases, the target refers to a single executable file.

The `Makefile` is processed by the `make` command, which identifies the target file or files to build. It then checks the timestamps of the source files to determine which rules must be executed to generate the desired target. Frequently, several intermediate targets must be created before the final one is built. The make command uses the makefile to figure out the proper build order and the appropriate sequence of rules to apply.

#### Tabs vs. spaces

In order for `make` to distinguish between a recipe and lines that are not part of a recipe, it relies on the presence of `TAB` characters.
Any line that starts with a `TAB` is interpreted as part of a **recipe**; this means it's treated as a **shell command** and passed to the shell for execution. 
Conversely, lines that do not start with a `TAB` are not considered part of a recipe; instead, they are interpreted as Makefile-syntax and not executed by the shell.

#### Dependencies

```Makefile
//The dependency list of the program above is as follows.
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

`Makefiles` allow you to define macros, making them more flexible and reusable. Macros are defined using `MACRONAME = value` and can be referenced with `$(MACRONAME)` or `${MACRONAME}`. If a macro is left empty (i.e., after the `=`), it can be omitted from the Makefile.

```Makefile
CC = gcc
INCLUDE = .
CFLAGS = -g -Wall –ansi
myProgram: main.o 2.o 3.o
    $(CC) -o myProgram main.o 2.o 3.o
main.o: main.c a.h
    $(CC) -I$(INCLUDE) $(CFLAGS) -c main.c
2.o: 2.c a.h b.h
    $(CC) -I$(INCLUDE) $(CFLAGS) -c 2.c
3.o: 3.c b.h c.h
    $(CC) -I$(INCLUDE) $(CFLAGS) -c 3.c
```

Here, we define `CC` as `gcc` so that one can easily change the compiler to other ones(e.g., clang, cc, etc.).  
Also, macros can be specified outside of `Makefile` using command-line; for example, `make CC=clang`.  

| Macro Definition  | Description                                                                               |
| :-:               | :-                                                                                        |
| $?                | A list of prerequisite files that have been updated more recently than the current target.|
| $@                | Refers to the name of the current target file.                                            |
| $<                | Represents the name of the first prerequisite in the rule.                                |
| $*                | Denotes the name of the current prerequisite, omitting its file extension.                |

#### Multiple Targets

It's often beneficial to produce multiple targets or group commands together in a more organized manner. To achieve this, you can enhance your `Makefile`. The example below, a `clean` target is introduced to delete unnecessary object files, while an `install` target is added to move the final application to a `/usr/local/bin` path.

```Makefile
CC = clang 
INSTDIR = /usr/local/bin
INCLUDE = .
CFLAGS = -g -Wall -ansi
# CFLAGS = -O -Wall -ansi
all: myProgram
myProgram: main.o 2.o 3.o
    $(CC) -o myProgram -I. main.o 2.o 3.o
main.o: main.c a.h
    $(CC) -c -I. main.c
2.o: 2.c a.h b.h
    $(CC) -c -I. 2.c
3.o: 3.c b.h c.h
    $(CC) -c -I. 3.c
clean:
    -rm main.o 2.o 3.o
install: myProgram
    @if [ -d $(INSTDIR) ]; \
        then \
        cp myProgram $(INSTDIR);\
        chmod a+x $(INSTDIR)/myProgram;\
        chmod og-w $(INSTDIR)/myProgram;\
        echo "Installed in $(INSTDIR).";\
    else \
        echo "Sorry, $(INSTDIR) does not exist";\
    fi
```

Let's take a look at each part.  

- `clean`
First, let's take a look at `clean`.
The command begins with a `-`, which instructs `make` to disregard the outcome of that command. This means that even if the command encounters an error, the make clean operation will still be considered successful.  

- `install`
Now let's take a look at `install`.
The `@` symbol instructs `make` to suppress the printing of the command to the standard output.  

#### Managing Libraries

For larger projects, it's good practice to organize multiple compilation outputs into a library. A library is typically a file with the `.a` extension (short for archive), which houses a collection of object files. The `make` command offers a dedicated syntax for working with libraries, simplifying their management. `lib(file.o)` refers to object file `file.o` stored within the library `lib.a`.

Take a look at this code:  
```Makefile
MYLIB = myLib.a
$(MYLIB): $(MYLIB)(2.o) $(MYLIB)(3.o)
```
This defines how to create the static library `mylib.a`. A static library is essentially an archive of object files. Here's how it works:  
The target `$(MYLIB)` (i.e., `mylib.a`) depends on object files `2.o` and `3.o`.  

The syntax `$(MYLIB)(2.o)` and `$(MYLIB)(3.o)` is a pattern rule that indicates that the object files `2.o` and `3.o` will be archived into the static library `mylib.a`.  

When you run `make`, the rule instructs `Make` to create `mylib.a` by archiving the `2.o` and `3.o` object files into it. This would typically use the `ar` tool (a utility for creating and managing archives).

So, the command to build `mylib.a` would look something like:

```shell
ar rv mylib.a 2.o 3.o
```
Where:
- `ar` is the archiver command.
- `r` tells ar to replace existing object files in the archive or add new files if they don't already exist.
- `v` makes the operation verbose.

-----------------------------------

### Options to `make`

| Options | Description                                                                                                |
| :-:     | :-                                                                                                         |
|`-k`     | keep going even when error is found.                                                                       |
|`-n`     | prints out what it would have done whithout actually doing it.                                             |
|`-f`     | specify which file to use as its makefile. default is `makefile` or `Makefile` in the current directory.   |



