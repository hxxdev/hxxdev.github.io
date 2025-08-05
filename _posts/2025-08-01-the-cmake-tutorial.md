---
title: The CMake Tutorial
date: 2025-08-01
categories: [dev, cpp]
tags: [cmake]
---

### What is CMake?

CMake is a cross-platform C/C++ build system generator. It's a tool that allows you
to take your source code and a build script and then generate build files for various toolchains and platforms.

CMake reads a script file named `CMakeLists.txt` and uses it to generate a native build script for your chosen compiler and toolchain (e.g., a Makefile for GNU Make or a solution file for Visual Studio).

---


### Why is it needed?

As a C project's size increases, so does the complexity of its Makefile.
For example, the Makefile for the Linux kernel is over 2000 lines long!
Makefiles become even more complicated when you add options for cross-platform compilation.
There is a clear need to automate the generation of these build scripts, and this is where CMake fits in.

---

### How do you use it?

Let's walk through a basic example.

1.  **Define your project in `CMakeLists.txt`.**

    Imagine a simple project with the following structure:
    ```
     project
    ├──  main.c
    ├──  helloworld.c
    └──  CMakeLists.txt
    ```
    Your `CMakeLists.txt` file would define the project and specify the source files to build the executable:
    ```cmake
    cmake_minimum_required(VERSION 3.10)

    project(HelloWorld)

    add_executable(helloworld main.c helloworld.c)
    ```

2.  **Run CMake to generate the build files.**

    It's best practice to create a separate directory for the build files to keep your source tree clean.
    ```shell
    mkdir build
    cmake -B build
    ```
    After running CMake, your project directory will look like this:
    ```
     project
    ├──  main.c
    ├──  helloworld.c
    ├──  CMakeLists.txt
    └── 󱧼 build
        ├──  Makefile
        ├──  CMakeCache.txt
        ├──  cmake_install.cmake
        └── 󱧼 CMakeFiles
    ```

3.  **Build your project using the generated build system.**

    Now you can use the generated Makefile to compile your project.
    ```shell
    cmake --build build
    or
    cd build && make
    ```
    This will create the executable in your build directory.
    ```
     project
    ├──  main.c
    ├──  helloworld.c
    ├──  CMakeLists.txt
    └── 󱧼 build
        ├──  Makefile
        ├──  CMakeCache.txt
        ├──  cmake_install.cmake
        ├── 󱧼 CMakeFiles
        └──  helloworld
    ```

4.  **Iterate on your code.**

    After modifying your source code, you only need to run `make` again from within the `build` directory.

5.  **Update dependencies.**

    If you add or remove source files, you'll need to update your `CMakeLists.txt` accordingly and then re-run CMake to regenerate the build files.

---

### How does it work?

CMake operates in three stages:

1.  **Configuration Stage:**
    - Reads the `CMakeLists.txt` file.
    - Executes the build logic defined in the script.
    - Creates a variable cache (`CMakeCache.txt`) to store configuration options.

2.  **Generation Stage:**
    - Runs a toolchain-specific generator.
    - Uses the output from the configuration stage.
    - Generates the build script for the target toolchain (e.g., `Makefile`).

3.  **Build Stage:**
    - Your chosen toolchain or build system (e.g., Make) does the actual compilation and linking.

---

### Using the Ninja Generator

The real power of CMake is that it can generate build files for many different build systems, not just Make. Other popular generators include:
- Ninja
- Visual Studio
- Xcode

Ninja is another build system designed to be significantly faster than Make. While its `build.ninja` files are complex and not meant to be written by hand, CMake can generate them for you. This allows you to benefit from Ninja's speed without the manual complexity.

To use the Ninja generator, you would run CMake like this:

```shell
cmake -G Ninja ..
```

---

### 🔧 CMake variables

| Project | Configuration |
| :-: | :- |
| CMAKE_BUILD_TYPE | Set build type: Debug, Release, RelWithDebInfo, MinSizeRel |
| CMAKE_INSTALL_PREFIX | Set installation directory |
| CMAKE_PROJECT_NAME | Name of the root project |
| CMAKE_CXX_STANDARD | C++ standard version (11, 17, 20, etc.) |
| CMAKE_EXPORT_COMPILE_COMMANDS | Generate compile_commands.json, which is very useful for external tools like IDEs, linters, and static analyzers (e.g., clangd) |
| BUILD_TESTING |global switch that controls whether the testing infrastructure for the entire project is enabled. |

---

### Summary

> CMake is a build system generator. It takes a high-level description of a project and generates native build files for your specific platform and toolchain.
