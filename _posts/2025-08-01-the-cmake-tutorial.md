---
title: The CMake Tutorial
date: 2025-08-01
categories: [dev, cpp]
tags: [cmake, c++, build-systems]
---

CMake is an essential tool for any C++ developer. It automates the process of building, testing, and packaging software. This tutorial will guide you through the basics of CMake and show you how to use it in your own projects.

### What is CMake and Why Should You Use It?

CMake is a **cross-platform build system generator**. That's a mouthful, so let's break it down.

-   **Build System:** A set of tools that compiles source code into a usable executable or library (e.g., Make, Ninja).
-   **Generator:** CMake doesn't build the code itself. Instead, it *generates* the configuration files for a build system (like a `Makefile` for Make or a `build.ninja` file for Ninja).
-   **Cross-Platform:** You can use the same CMake script (`CMakeLists.txt`) to generate build files for different operating systems (Linux, macOS, Windows) and compilers (GCC, Clang, MSVC).

**The Problem:** Manually writing `Makefile`s is tedious and error-prone. A simple project is manageable, but as your codebase grows, so does the complexity. Supporting different platforms and compilers can turn your build scripts into a nightmare.

**The Solution:** CMake provides a high-level, human-readable language to describe your project's structure and dependencies. It handles the low-level, platform-specific details for you.

---

### Getting Started: A Simple Executable

Let's start with a classic "Hello, World!" C++ project.

1.  **Project Structure:**

    ```
     project
    ├──  main.cpp
    └──  CMakeLists.txt
    ```

2.  **Source Code (`main.cpp`):**

    ```cpp
    #include <iostream>

    int main() {
        std::cout << "Hello, CMake!" << std::endl;
        return 0;
    }
    ```

3.  **The `CMakeLists.txt` script:**

    This file is the heart of your CMake project. It tells CMake everything it needs to know about your project.

    ```cmake
    # Specify the minimum version of CMake required.
    cmake_minimum_required(VERSION 3.10)

    # Set the project name and language.
    project(HelloWorld CXX)

    # Add an executable target.
    # CMake will create an executable named "helloworld"
    # from the source file "main.cpp".
    add_executable(helloworld main.cpp)
    ```

4.  **Generating the Build Files:**

    It's best practice to perform an "out-of-source" build. This keeps your source directory clean by placing all build-related files in a separate directory (e.g., `build/`).

    ```shell
    # Create a build directory
    mkdir build

    # Run CMake from the project root to generate build files inside ./build
    cmake -B build
    ```

5.  **Building the Executable:**

    Now, you can use CMake's build driver, which will invoke the underlying build system (like Make).

    ```shell
    cmake --build build
    ```

    This command will compile `main.cpp` and create an executable named `helloworld` inside the `build` directory. You can run it with `./build/helloworld`.

---

### Adding a Library

Most projects are more complex than a single file. Let's refactor our code into a library and an executable that uses it. This is a common and highly recommended practice.

1.  **New Project Structure:**

    ```
     project
    ├──  main.cpp
    ├──  greeter.cpp
    ├──  greeter.h
    └──  CMakeLists.txt
    ```

2.  **Source Files:**

    **`greeter.h`**
    ```cpp
    #pragma once
    #include <string>
    void greet(const std::string& name);
    ```

    **`greeter.cpp`**
    ```cpp
    #include "greeter.h"
    #include <iostream>
    void greet(const std::string& name) {
        std::cout << "Hello, " << name << "!" << std::endl;
    }
    ```

    **`main.cpp`**
    ```cpp
    #include "greeter.h"
    int main() {
        greet("CMake");
        return 0;
    }
    ```

3.  **Updated `CMakeLists.txt`:**

    We now need to tell CMake to build a library and then link our executable against it.

    ```cmake
    cmake_minimum_required(VERSION 3.10)
    project(HelloWorld CXX)

    # Create a library target named "greeter"
    # from greeter.cpp and greeter.h.
    add_library(greeter greeter.cpp greeter.h)

    # Create the executable.
    add_executable(helloworld main.cpp)

    # Link the "helloworld" executable against the "greeter" library.
    # This ensures the executable can use the functions from the library.
    target_link_libraries(helloworld PRIVATE greeter)
    ```

    Now, when you run `cmake -B build` and `cmake --build build`, CMake will first compile the `greeter` library and then build the `helloworld` executable, linking them together.

---

### Important CMake Commands and Variables

As your projects grow, you'll use more of CMake's features. Here are some of the most important commands and variables.

#### Key Commands

-   `add_library(name [STATIC | SHARED] source1 [source2 ...])`: Creates a library target.
-   `target_include_directories(target [PUBLIC | PRIVATE | INTERFACE] dir1 [dir2 ...])`: Specifies include directories for a target. This is how you tell CMake where to find header files.
-   `target_link_libraries(target [PUBLIC | PRIVATE | INTERFACE] lib1 [lib2 ...])`: Links a target against other libraries.
-   `find_package(PackageName [VERSION] [REQUIRED])`: Finds and loads settings from an external package (e.g., Boost, Qt).
-   `install(TARGETS ...)`: Defines rules for installing your project's targets (executables, libraries).

#### Key Variables

You can set these variables on the command line using the `-D` flag (e.g., `cmake -D CMAKE_BUILD_TYPE=Release ..`).

| Variable                      | Description                                                                                                                            |
| ----------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| `CMAKE_BUILD_TYPE`            | Sets the build type: `Debug`, `Release`, `RelWithDebInfo`, `MinSizeRel`.                                                                 |
| `CMAKE_CXX_STANDARD`          | Specifies the C++ standard (e.g., `11`, `14`, `17`, `20`). Requires CMake 3.8+.                                                          |
| `CMAKE_INSTALL_PREFIX`        | The directory where the project will be installed when you run `make install`.                                                         |
| `CMAKE_EXPORT_COMPILE_COMMANDS` | Set to `ON` to generate a `compile_commands.json` file, which is very useful for external tools like IDEs and linters (e.g., clangd). |
| `BUILD_TESTING`               | A common convention to enable or disable building tests (`ON`/`OFF`). Often used with CTest, CMake's testing framework.                |

---

### Choosing a Generator (e.g., Ninja)

CMake's real power comes from its generator system. By default, on Linux, it generates Makefiles. But you can easily switch to another build system like **Ninja**, which is known for its speed.

To use Ninja, you first need to install it (`sudo apt-get install ninja-build` or `brew install ninja`). Then, tell CMake to use the Ninja generator with the `-G` flag:

```shell
# Generate build files for Ninja
cmake -G Ninja -B build
```

Now, the `cmake --build build` command will use Ninja instead of Make to build your project, which can be significantly faster.

---

### Summary

CMake is a powerful tool that simplifies the build process for C/C++ projects. It allows you to define your project in a high-level, platform-agnostic way and generates native build files for you.

This tutorial has only scratched the surface. As a next step, explore how to use `find_package` to incorporate third-party libraries and how to use CTest to write and run tests for your project.