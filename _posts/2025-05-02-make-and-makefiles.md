---
title: A Comprehensive Guide to make and Makefiles
date: 2025-05-02
categories: [dev, cpp]
tags: [make]
---

This post explains the **make command and Makefiles**

---

### Makefiles

A `Makefile` usually resides in the same directory as the other source files. It tells how your program is constructed to the `make` command.

Using the `make` command together with a `Makefile` offers a highly effective way to manage and organize project builds.

🧠 What a Makefile does?

✅ Defines rules to automate tasks

Each rule tells make:  
1. What to build (target)
2. How to build it (commands)
3. What it depends on (dependencies)

✅ 2. Tracks file changes
make only rebuilds what’s changed, using timestamps. It makes builds efficient.

---

### Installation

In Ubuntu OS, `make` can be installed by:

```shell
sudo apt install make
```

---

### How to write Makefiles

A `Makefile` is made up of a series of dependencies and rules. Each dependency includes a target (the file that needs to be generated) and one or more source files that it relies on. The rules specify the steps required to produce the target from its dependent files. In most cases, the target refers to a single executable file.

The `Makefile` is processed by the `make` command, which identifies the target file or files to build. It then checks the timestamps of the source files to determine which rules must be executed to generate the desired target. Frequently, several intermediate targets must be created before the final one is built. The make command uses the makefile to figure out the proper build order and the appropriate sequence of rules to apply.

---

#### Tabs vs. spaces

In order for `make` to distinguish between a recipe and lines that are not part of a recipe, it relies on the presence of `TAB` characters.
Any line that starts with a `TAB` is interpreted as part of a **recipe**; this means it's treated as a **shell command** and passed to the shell for execution. 
Conversely, lines that do not start with a `TAB` are not considered part of a recipe; instead, they are interpreted as Makefile-syntax and not executed by the shell.

---

#### Dependencies

```
//The dependency list of the program above is as follows.
myProgram: main.o 2.o 3.o
main.o: main.c a.h
2.o: 2.c a.h b.h
3.o: 3.c a.h b.h c.h
```

This `Makefile` says that `myProgram` is dependent on `main.o`, `2.o` and `3.o`.
`main.o` is dependent on `main.c` and `a.h`.

---

#### Target

```
myProgram: main.o 2.o 3.o
  gcc -o myProgram main.o 2.o 3.o
main.o: main.c a.h
  gcc -c main.c
2.o: 2.c a.h b.h
  gcc -c 2.c
3.o: 3.c b.h c.h
  gcc -c 3.c
```
Note that `gcc` commands are indented by `TAB`s.  
This `Makefile` tells which command needs to be run to generate each file.  
Taking `3.o` into instance, `make` command reads this `Makefile` and run `gcc -c 3.c` to generate `3.o` if needed.  

---

#### Macros

`Makefiles` allow you to define macros, making them more flexible and reusable. Macros are defined using `MACRONAME = value` and can be referenced with `$(MACRONAME)` or `${MACRONAME}`. If a macro is left empty (i.e., after the `=`), it can be omitted from the Makefile.

```
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

---

#### Phony targets

The word **phony** means **false or fake**. In `Makefile`:
- A phony target is a target that **does not correspond to an actual file**.
- It’s essentially a name for an action you want to run, rather than something that should be built or generated.
Take a look at this code:

```
CC = gcc
NODEPS = clean install
CFLAGS = -Wall -g
SRC = $(wildcard *.cpp)
OBJ = $(SRC:.cpp=.o)
INSTDIR = /usr/bin/local

.PHONY: $(NODEPS)

all: myProgram

myProgram: $(OBJ)
	$(CC) $(CFLAGS) -o $@

# Compile the source files
%.o: %.cpp
  $(CC) $(CFLAGS) -c $< -o $@

clean:
	-rm -rf obj pch dep pch
	-rm -f *.exe
	@echo "Project has been cleaned successfully."

install: myProgram.exe
	@if [ -d $(INSTDIR) ]; \
		then \
		cp myProgram.exe $(INSTDIR);\
		chmod a+x $(INSTDIR)/myProgram.exe;\
		chmod og-w $(INSTDIR)/myProgram.exe;\
		echo "Installed in $(INSTDIR)."\
	else \
		echo "Sorry, $(INSTDIR) does not exist"\
	fi

```

This tells `make` that the targets listed in `$(NODEPS)` are phony targets. Even if a file or directory named the same as any of these targets exists, `make` will still execute the rules for these targets. The `.PHONY` target in a Makefile is used to declare that certain targets are not actual files, but rather phony targets that should always be executed, even if there happens to be a file with the same name.

Let's take a look at each part.  

```
clean:
	-rm -rf obj pch dep pch
	-rm -f *.exe
	@echo "Project has been cleaned successfully."
```

The command begins with a `-`, which instructs `make` to disregard the outcome of that command. This means that even if the command encounters an error, the make clean operation will still be considered successful.  

```
@if [ -d $(INSTDIR) ]; \
	then \
	cp myProgram.exe $(INSTDIR);\
	chmod a+x $(INSTDIR)/myProgram.exe;\
	chmod og-w $(INSTDIR)/myProgram.exe;\
	echo "Installed in $(INSTDIR).";\
else \
	echo "Sorry, $(INSTDIR) does not exist";\
fi
```
The `@` symbol instructs `make` to suppress the printing of the command to the standard output. Also note that they are indented by `TAB` since they are written in shell scripts. Also, they are terminated by `;` and `\` each command.

---

#### Managing Libraries

For larger projects, it's good practice to organize multiple compilation outputs into a library. A library is typically a file with the `.a` extension (short for archive), which houses a collection of object files. The `make` command offers a dedicated syntax for working with libraries, simplifying their management. `lib(file.o)` refers to object file `file.o` stored within the library `lib.a`.

Take a look at this code:  
```
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

---

#### Generating dependency file

In large projects, it is *burdensome* to write all dependencies by hand.  

Many compilers such as `gcc` and `clang` provide automatic **dependencies generation**.  

You can generate dependency files(`.d`) using compiler and include the dependency in `Makefile`.


Take a look at this code:  

```
CC = gcc
NODEPS = clean install
CFLAGS = -Wall -g
SRC = $(wildcard *.cpp) $(wildcard *.h)
OBJ = $(SRC:.cpp=.o)
DEP = $(patsubst %.cpp, %.d, $(SRC))

.PHONY: $(NODEPS)

all: myProgram

myProgram: $(OBJ)
	$(CC) $(CFLAGS) -o $@

# Compile the source files
%.o: %.cpp
  $(CC) $(CFLAGS) -c $< -o $@

ifeq (0, $(words $(findstring $(MAKECMDGOALS), $(NODEPS))))
  -include $(DEP)
endif

# Include the dependency files
-include $(DEP)

# Generate the dependency files (.d)
%.d: %.cpp
	$(CC) $(CFLAGS) -MM $< > $@
```

Explanation of code:  

```
SRC = $(wildcard *.cpp) $(wildcard *.h)
```

This sets the `SRC` variable to a list of all the `.cpp` and `.h` files in the current directory.

```
OBJ = $(SRC:.cpp=.o)
```

This sets the `OBJ` variable to a list of object files corresponding to the source files.  
`$(SRC:.cpp=.o)` is a pattern substitution. It replaces the `.cpp` extension of each file in `SRC` with `.o`, essentially turning a list of C++ source files into a list of object files.  

```
DEP = $(OBJ:.o=.d)
```

This sets the `DEP` variable to a list of dependency files (with `.d` extension), one for each object file.  

```
$(OBJ): %.o: %.cpp
    $(CC) $(CFLAGS) -cpp $< -o $@
```

%.o: %.cpp` means: For each `.o` file, you build it from a corresponding `.cpp` file.  
`$(CC) $(CFLAGS) -c $< -o $@` is the command used to compile a source file into an object file:
- `-c` tells the compiler to compile the source into an object file (not a full executable).
- `$<` refers to the first prerequisite in the rule (the `.cpp` file).
- `$@` refers to the target of the rule (the `.o` file).

```
ifeq (0, $(words $(findstring $(MAKECMDGOALS), $(NODEPS))))
  -include $(DEP)
endif
```
The `ifeq` statement checks if the goals specified in $(MAKECMDGOALS) do not match any items in the $(NODEPS) list. `-include` tells `make` to include the `.d` files (dependencies) in the `Makefile`. It ensures that `make` doesn't complain if the `.d` files do not exist initially (which is usually the case when you first run make). This kind of setup is useful if you want to *skip including dependency files* when running specific goals (like `make clean` or `make install`), but include them for other goals (like building the program).


```
%.d: %.cpp
  $(CC) $(CFLAGS) -MMD $< > $@
```

This line generates dependency files (`%.d`) from the corresponding source files (`%.cpp`):
- `-MD` tells compiler to generate a dependency file, which lists all the header files that the source file includes.
    - `gcc -M` will generate basic dependencies.
    - `gcc -MM` will ignore system headers.
    - `gcc -MMD` will generate a `.d` file, excluding system headers.
- `$<` is the first prerequisite (the `.c` file).
- `$@` is the target (the `.d` file).



---

#### Static Pattern Rules

[Static pattern rules](https://www.gnu.org/software/make/manual/html_node/Static-Pattern.html) are rules that define multiple targets and generate the prerequisite names for each target based on the target’s name. Unlike regular rules with multiple targets, these rules are more flexible, as the targets do not need to share the same exact prerequisites. While the prerequisites must follow a similar pattern, they don't have to be identical.

The syntax of static pattern rules is:

```
targets : target-pattern: prereq-patterns
  recipe
  ...
```

The `target` is matched against the `target-pattern` to extract the `stem`, which is then substituted into the `prereq-patterns` to form the prerequisite names. Let's look at some examples:

```
CSOURCES = $(shell find ./src/ -name "*.cpp")
COBJECTS = $(patsubst ./src/%.cpp, ./obj/%.o, $(CSOURCES))
$(COBJECTS): ./obj/%.o: ./src/%.cpp # static pattern rule
@mkdir -p obj
$(CC) $(CFLAGS) -c $< -o $@
```

In this code, `$(COBJECTS)` is a list of object files(say, `./obj/a.o`, `./obj/b.o`, `./obj/c.o`).  
`$(COBJECTS)` is used as `targets` and `target-pattern` is written as `./obj/%.o`.  
Therefore, `./obj/a.o` will be matched against `./obj/%.o` giving `stem(%)` as `a`.
Same principles apply to `./obj/b.o` and `./obj/c.o`.

---

### Options to `make`

| Options | Description                                                                                                |
| :-:     | :-                                                                                                         |
|`-k`     | keep going even when error is found.                                                                       |
|`-n`     | prints out what it would have done whithout actually doing it.                                             |
|`-f`     | specify which file to use as its makefile. default is `makefile` or `Makefile` in the current directory.   |

---

### Final Makefile

Let’s bring together the concepts we’ve covered so far. This includes defining targets and dependencies, using macros for flexibility, handling multiple build actions, and organizing output with static libraries. The following `Makefile` demonstrates a practical and comprehensive setup that incorporates these elements.

```
# Project path configurations
PATH_CSOURCE = ./src
PATH_CINCLUDE = ./include
PATH_COBJECT = ./obj
PATH_DLLSOURCE = ./dll/src
PATH_DLLINCLUDE = ./dll/include
PATH_DLLOBJECT = ./dll/obj
PATH_ASMSOURCE = ./dll/asm
PATH_ASMOBJECT = $(PATH_DLLOBJECT)
PATH_DEBUG = ./debug
PATH_RELEASE = ./release

# Makefile verbose configurations
ifeq ($(VERBOSE),1)
    Q =
else
    Q = @
endif

# Compiler configurations
ASM = nasm
CC = clang++
INSTDIR ?= /usr/local/bin
SYSINCLUDES = -I/usr/x86_64-w64-mingw32/include
PROJINCLUDES = -I$(PATH_CINCLUDE) -I$(PATH_DLLINCLUDE)
INCLUDES = $(SYSINCLUDES) $(PROJINCLUDES)
CPPFLAGS = -MMD -MP $(INCLUDES)
CXXFLAGS = --target=x86_64-w64-mingw32 -Wall
LDFLAGS = -lkernel32 -luser32 -lm -lstdc++
EXE = myProgram.exe
DLL = myDll.dll
ifneq ($(filter release install, $(MAKECMDGOALS)),)
    CXXFLAGS += -O2
    BUILDDIR := $(PATH_RELEASE)
    EXE := $(BUILDDIR)/$(EXE)
    DLL := $(BUILDDIR)/$(DLL)
else
	CXXFLAGS += -g -O0 -DDEBUG
    BUILDDIR := $(PATH_DEBUG)
    EXE := $(BUILDDIR)/$(EXE)
    DLL := $(BUILDDIR)/$(DLL)
endif

# Color variables
WHITE = \033[1;37m
GREEN = \033[0;32m
RED = \033[0;31m
RESET = \033[0m

# dont generate dependency when running make clean, help.
.PHONY: clean help

# list of cproject files
CSOURCES = $(shell find $(PATH_CSOURCE) -maxdepth 1 -name "*.cpp")
COBJECTS = $(patsubst $(PATH_CSOURCE)/%.cpp, $(PATH_COBJECT)/%.o, $(CSOURCES))

# list of dllproject files
DLLSOURCES = $(shell find $(PATH_DLLSOURCE) -maxdepth 1 -name "*.cpp")
DLLOBJECTS = $(patsubst $(PATH_DLLSOURCE)/%.cpp, $(PATH_DLLOBJECT)/%.o, $(DLLSOURCES))
ASSEMBLIES = $(shell find $(PATH_ASMSOURCE) -maxdepth 1 -name "*.asm")
ASMOBJECTS = $(patsubst $(PATH_ASMSOURCE)/%.asm, $(PATH_DLLOBJECT)/%.o, $(ASSEMBLIES))

# echo your configurations
ifeq ($(VERBOSE),1)
    $(info =====Project Configuration=====)
    $(info CSOURCES: $(CSOURCES))
    $(info COBJECTS: $(COBJECTS))
    $(info DLLSOURCES: $(DLLSOURCES))
    $(info DLLOBJECTS: $(DLLOBJECTS))
    $(info ASSEMBLIES: $(ASSEMBLIES))
    $(info ASMOBJECTS: $(ASMOBJECTS))
    $(info ===============================)
endif

all: debug

debug: $(EXE) $(DLL)
release: $(EXE) $(DLL)

-include $(COBJECTS:.o=.d) $(DLLOBJECTS:.o=.d)

$(EXE): $(COBJECTS)
	$(Q)mkdir -p $(BUILDDIR)
	$(Q)$(CC) $(CPPFLAGS) $(CXXFLAGS) $(LDFLAGS) $(COBJECTS) -o $@ && \
	echo "$(GREEN)Built: $@ ($$(du -h $@ | cut -f1))$(RESET)"
	
$(DLL): $(DLLOBJECTS) $(ASMOBJECTS)
	$(Q)mkdir -p $(BUILDDIR)
	$(Q)$(CC) $(CPPFLAGS) $(CXXFLAGS) $(LDFLAGS) $(DLLOBJECTS) $(ASMOBJECTS) -shared -o $@ && \
	echo "$(GREEN)Built: $@ ($$(du -h $@ | cut -f1))$(RESET)"

$(COBJECTS): $(PATH_COBJECT)/%.o: $(PATH_CSOURCE)/%.cpp
	$(Q)mkdir -p $(PATH_COBJECT)
	$(Q)$(CC) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

$(DLLOBJECTS): $(PATH_DLLOBJECT)/%.o: $(PATH_DLLSOURCE)/%.cpp
	$(Q)mkdir -p $(PATH_DLLOBJECT)
	$(Q)$(CC) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

$(ASMOBJECTS): $(PATH_ASMOBJECT)/%.o: $(PATH_ASMSOURCE)/%.asm
	$(Q)mkdir -p $(PATH_ASMOBJECT)
	$(Q)$(ASM) $< -f win64 -o $@

clean:
	$(Q)rm -rf $(PATH_COBJECT) $(PATH_DLLOBJECT) $(PATH_ASMOBJECT) $(PATH_DEBUG) $(PATH_RELEASE)
	$(Q)rm -f $(EXE) $(DLL)
	$(Q)echo "Project has been cleaned successfully."

install: release
	$(Q)sudo install -m 755 $(EXE) $(INSTDIR)
	$(Q)echo "$(GREEN)Installed release binary to $(INSTDIR)$(RESET)"

help:
	$(Q)echo "$(WHITE)release: build release$(RESET)"
	$(Q)echo "$(WHITE)Usage: make release$(RESET)"
	$(Q)echo "$(WHITE)VERBOSE: echo all running commands$(RESET)"
	$(Q)echo "$(WHITE)Usage: make VERBOSE=1$(RESET)"
```

---

### Making your Makefile cross-platform

In this section, we will talk about how to write cross-platfrom compatible Makefile.  

Writing your Makefile like this for example will not allow you to use it on Windows:

```makefile
clean:
	rm -f *.o app
```

However, OS detection can be done like this:
```
ifeq ($(OS),Windows_NT)
    RM = del
else
    RM = rm -f
endif

clean:
	$(RM) *.o app
```

---

### References
[1] [GNU Make Manual](https://www.gnu.org/software/make/manual/)

